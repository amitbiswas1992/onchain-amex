import '../error/app_exception.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Ok] with a value of type [T]
/// or an [Error] with an [Exception].
///
/// Use [Result.ok] to create a successful result with a value of type [T].
/// Use [Result.error] to create an error result with an [Exception].
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value, {required String message}) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(AppException error) = Error._;
}

/// A successful [Result] with a returned [value].
final class Ok<T> extends Result<T> {
  const Ok._(this.value, {required this.message});

  /// The returned value of this result.
  final T value;

  final String message;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// An error [Result] with a resulting [error].
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// The resulting error of this result.
  final AppException error;

  @override
  String toString() => '$error';
}