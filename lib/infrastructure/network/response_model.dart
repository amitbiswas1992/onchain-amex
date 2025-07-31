import '../error/app_exception.dart';
import 'result.dart';

class ResponseModel {
  bool success;
  String message;
  dynamic body;

  ResponseModel({
    this.success = false,
    this.message = '',
    this.body,
  });

  ResponseModel get noInternetResponse => ResponseModel(message: 'No internet connection!');

  Result<T?> toResult<T>({required T? Function(dynamic)? dataHandler}) {
    return success
        ? Result.ok(dataHandler?.call(body), message: message)
        : Result.error(
            AppException(message: message),
          );
  }
}
