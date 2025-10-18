import 'dart:core';

class ApiUrls {
  ApiUrls._();

  static const base = 'https://paytmrw.com/';
  static const register = '/api/v1/auth/register';
  static const registerWIthPhone = '/api/v1/auth/phone/register';
  static const sendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const verifyOtpForEmail = '/api/v1/auth/verify-email-otp';
  static const verifyOtpForPhone = '/api/v1/auth/phone/verify-otp';
  static const resendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const resendOtpToPhone = '/api/v1/auth/phone/send-otp';
  static const login = '/api/v1/auth/login';
  static const loginWIthPhone = '/api/v1/auth/phone/login';
  static const connectWallet = '/api/v1/blockchain/creditor/admin/borrower/register';
  static const profile = '/api/v1/auth/profile';
  static const refreshToken = '/api/v1/auth/refresh';
  static deleteUser(String userID) => '/api/v1/users/$userID';

  static const availableCredit = '/api/v1/blockchain/creditor/borrower/available-credit';
  static borrowerProfile(String publicAddress) => '/api/v1/blockchain/creditor/borrower/profile';
  static const logOut = '/api/v1/auth/logout';
  static const deviceSessions = '/api/v1/users/devices/sessions';
  static deleteDeviceSession(String deviceId) => '/api/v1/users/devices/$deviceId';
  static const updateKycStatus = '/api/v1/kyc/update-status';
  static transactionsHistory(String publicAddress) => '/api/v1/blockchain/creditor/borrower/transactions';
}