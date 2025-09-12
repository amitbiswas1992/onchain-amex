import 'dart:core';

class ApiUrls {
  ApiUrls._();

  static const base = 'https://paytmrw.com/';
  static const register = '/api/v1/auth/register';
  static const sendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const verifyOtpForEmail = '/api/v1/auth/verify-email-otp';
  static const resendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const login = '/api/v1/auth/login';

}