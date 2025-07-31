import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../di/get_it_service.dart';
import 'connectivity_service.dart';
import 'headers_service.dart';
import 'response_model.dart';

class DioService {
  late final Dio dio;
  final HeadersService headersService;

  DioService({required this.headersService}) {
    _initialize();
  }

  void _initialize() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    );

    dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
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

  Future<bool> _hasConnection() async {
    return await getIt<ConnectivityService>().checkInternet();
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
      if (await getIt<ConnectivityService>().checkInternet() == false) {
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
