import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/services/secured_storage_service.dart';
import '../../modules/signin/data/models/tokens_model.dart';
import '../navigation/app_nav.dart';
import '../navigation/rt_nm.dart';
import 'api_urls.dart';
import 'connectivity_service.dart';
import 'headers_service.dart';
import 'response_model.dart';

class DioService {
  late final Dio dio;
  final HeadersService headersService;
  final ConnectivityService connectivityService;

  DioService({required this.headersService, required this.connectivityService}) {
    _initialize();
  }

  void _initialize() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrls.base,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
    );

    dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final data = error.requestOptions.data;
          final payloadLog = data is FormData ? 'FormData(...)' : jsonEncode(data);

          log(
            '''🔗 url:: ${error.requestOptions.method} -> ${error.requestOptions.uri}
      ｛｝ query:: ${jsonEncode(error.requestOptions.queryParameters)}
      {} headers: ${jsonEncode(error.requestOptions.headers)}
      {} payload:: $payloadLog
      🔢 status_code: ${error.response?.statusCode}
      🌐 response: ${jsonEncode(error.response?.data)}
      ''',
          );

          // 🔑 handle 401 here
          log('handling 401');
          if (error.response?.statusCode == 401 && !_isRefreshRequest(error.requestOptions)) {
            final success = await _refreshAuthTokens();
            if (success) {
              final retryResponse = await _retryRequest(error.requestOptions);
              if (retryResponse.statusCode == 401) {
                await _forceLogout(); // Only logout if retry is still 401
                return handler.reject(error);
              }
              return handler.resolve(retryResponse); // OK for 400/200/201 etc.
            } else {
              await _forceLogout(); // Logout if refresh failed
              return handler.reject(error);
            }
          }

          return handler.next(error);
        },
        onRequest: (request, handler) {
          return handler.next(request);
        },
        onResponse: (response, handler) {
          final data = response.requestOptions.data;
          final payloadLog = data is FormData ? 'FormData(...)' : jsonEncode(data);

          log(
            '''\nurl:: ${response.requestOptions.method} -> ${response.requestOptions.uri}
      ｛｝ query:: ${jsonEncode(response.requestOptions.queryParameters)}
      {} headers: ${jsonEncode(response.requestOptions.headers)}
      {} payload:: $payloadLog
      🔢 status_code: ${response.statusCode}
      🌐 response: ${jsonEncode(response.data)}
      ''',
          );

          return handler.next(response);
        },
      ),
    );
    log('dio initialized');
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final tokens = await headersService.securedStorageService.getUserTokens();
    final headers = {
      ...requestOptions.headers,
      if (tokens != null) 'Authorization': 'Bearer ${tokens.accessToken}',
    };

    final options = Options(
      method: requestOptions.method,
      headers: headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: (status) => status != null, // Treat all HTTP status codes as valid
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }


  Future<bool> _refreshAuthTokens() async {
    try {
      final tokens = await headersService.securedStorageService.getUserTokens();
      if (tokens == null) return false;

      final response = await dio.post(
        ApiUrls.refreshToken,
        data: {'refreshToken': tokens.refreshToken},
        options: Options(headers: headersService.defaultHeaders),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newTokens = TokensModel.fromJson(response.data['data']);
        await headersService.securedStorageService.saveUserTokens(newTokens);
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _forceLogout() async {
    await headersService.securedStorageService.deleteUserTokens();
    AppNav.goRouter.go(RtNm.splashScreen);
  }

  bool _isRefreshRequest(RequestOptions options) {
    return options.path.contains(ApiUrls.refreshToken);
  }

  Future<bool> _hasConnection() async {
    return await connectivityService.checkInternet();
  }

  Future<Map<String, String>?> _getHeaders({bool useTokenizeHeader = false}) async {
    return useTokenizeHeader
        ? await headersService.getTokenizedHeaders()
        : headersService.defaultHeaders;
  }

  Future<Map<String, String>?> _getMultipartHeaders({bool useTokenizeHeader = false}) async {
    return useTokenizeHeader
        ? await headersService.getMultipartTokenizedHeaders()
        : headersService.defaultHeaders;
  }

  ResponseModel _handleDioException(DioException e) {
    String errorMessage;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timed out. Please try again.';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate. Cannot verify SSL.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection.';
        break;
      case DioExceptionType.badResponse:
        final errors = (e.response?.data['errors'] ?? <String>[]) as List;
        errorMessage = (e.response?.data['message'] ?? 'Server error') +
            (errors.isNotEmpty ? ', ' : '') +
            errors.map((e) => e.toString()).join(', ');
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled.';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'An unknown network layer error occurred.';
        break;
    }

    return ResponseModel(success: false, message: errorMessage);
  }

  Future<ResponseModel> get(
    String url, {
    Map<String, String>? query,
    bool useTokenizeHeader = false,
    Map<String, String>? headers,
  }) async {
    try {
      if (await _hasConnection() == false) {
        return ResponseModel().noInternetResponse;
      }

      final response = await dio.get(
        url,
        options: Options(
          headers: headers ?? await _getHeaders(useTokenizeHeader: useTokenizeHeader),
        ),
        queryParameters: query,
      );

      Map<String, dynamic> jsonData = response.data;

      final obj = ResponseModel(
        success: jsonData['success'],
        body: jsonData['data'],
      );
      return obj;
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> post(
    String url, {
    bool useTokenizeHeader = false,
    Map<String, String>? headers,
    Map? body,
    Map<String, dynamic>? query,
  }) async {
    try {
      if (await connectivityService.checkInternet() == false) {
        return ResponseModel().noInternetResponse;
      }

      log('''
      ｛｝ payload:: ${jsonEncode(body)}
      ''');

      final response = await dio.post(
        url,
        queryParameters: query,
        options: Options(
          headers: headers ?? await _getHeaders(useTokenizeHeader: useTokenizeHeader),
        ),
        data: body,
      );

      Map<String, dynamic> jsonData = response.data;

      final obj = ResponseModel(
        success: jsonData['success'] ?? false,
        message: jsonData['message'] ?? '',
        body: jsonData['data'],
      );
      return obj;
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> uploadMultipart(
    String url, {
    required List<MultipartFile> files,
    String fileFieldName = 'file',
    bool useTokenizeHeader = false,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      if (await _hasConnection() == false) {
        return ResponseModel().noInternetResponse;
      }

      final Map<String, dynamic> formMap = {
        if (body != null) ...body,
      };

      if (files.length == 1) {
        formMap[fileFieldName] = files.first;
      } else {
        formMap[fileFieldName] = files;
      }

      final formData = FormData.fromMap(formMap);

      final response = await dio.post(
        url,
        data: formData,
        queryParameters: query,
        options: Options(
          headers: headers ?? await _getMultipartHeaders(useTokenizeHeader: useTokenizeHeader),
          // contentType: 'multipart/form-data',
        ),
      );

      Map<String, dynamic> jsonData = response.data;

      return ResponseModel(
        success: jsonData['success'] ?? false,
        message: jsonData['message'] ?? '',
        body: jsonData['data'],
      );
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> patch(
    String url, {
    bool useTokenizeHeader = false,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      if (await _hasConnection() == false) {
        return ResponseModel().noInternetResponse;
      }

      final response = await dio.patch(
        url,
        queryParameters: query,
        options: Options(
          headers: headers ?? await _getHeaders(useTokenizeHeader: useTokenizeHeader),
        ),
        data: body,
      );

      Map<String, dynamic> jsonData = response.data;

      final obj = ResponseModel(
        success: jsonData['success'] ?? false,
        message: jsonData['message'] ?? '',
        body: jsonData['data'],
      );
      return obj;
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> put(
    String url, {
    bool useTokenizeHeader = false,
    Map<String, String>? headers,
    Map? body,
    Map<String, dynamic>? query,
  }) async {
    try {
      if (await _hasConnection() == false) {
        return ResponseModel().noInternetResponse;
      }

      final response = await dio.put(
        url,
        queryParameters: query,
        options: Options(
          headers: headers ?? await _getHeaders(useTokenizeHeader: useTokenizeHeader),
        ),
        data: body,
      );

      Map<String, dynamic> jsonData = jsonDecode(response.data);

      final obj = ResponseModel(
        success: jsonData['success'] ?? false,
        message: jsonData['message'] ?? '',
        body: jsonData['data'],
      );
      return obj;
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

// Future<ResponseModel> upload(
//   String url, {
//   required File file,
//   Map<String, dynamic>? body,
//   Map<String, dynamic>? query,
// }) async {
//   try {
//     if (await InternetCheckup.instance.checkInternet() == false) {
//       return ResponseModel().noInternetResponse;
//     }
//
//     var request = http.MultipartRequest(
//       'post',
//       Uri.parse(url).replace(
//         queryParameters: query,
//       ),
//     )
//       // ..files.add(
//       //   await http.MultipartFile.fromPath(
//       //     'file',
//       //     file.path,
//       //     contentType: MediaType('application', 'x-tar'),
//       //   ),
//       // )
//       ..headers.addAll(GlobalVariables.header);
//
//     if (file.path.isNotEmpty) {
//       var stream = http.ByteStream(file.openRead());
//       var length = await file.length();
//
//       var multipartFile = http.MultipartFile(
//         'file',
//         stream,
//         length,
//         filename: file.path.split('/').last,
//         contentType: MediaType('application', 'x-tar'),
//       );
//
//       request.files.add(multipartFile);
//     }
//
//     if (body != null) {
//       body.forEach((key, value) {
//         request.fields[key] = value.toString();
//       });
//     }
//
//     var response = await http.Response.fromStream(await request.send());
//
//     Map<String, dynamic> jsonData = jsonDecode(response.body);
//
//     debugPrint('🔗 url:: $url\n🔢 status_code: ${response.statusCode}\n🌐 response: ${jsonEncode(jsonData)}');
//
//     final obj = ResponseModel(
//       success: jsonData['success'] ?? false,
//       message: jsonData['message'] ?? '',
//       body: jsonData['data'],
//     );
//     return obj;
//   } catch (e) {
//     rethrow;
//   }
// }
}
