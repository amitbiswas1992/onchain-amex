import 'dart:core';

class ApiUrls {
  ApiUrls._();

  static const base = 'https://onchain-amex.tanvirmahin.com';
  static const register = '/api/v1/auth/register';
  static const registerWIthPhone = '/api/v1/auth/phone/register';
  static const sendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const verifyOtpForEmail = '/api/v1/auth/verify-email-otp';
  static const verifyOtpForPhone = '/api/v1/auth/phone/verify-otp';
  static const resendOtpToEmail = '/api/v1/auth/send-email-verification-otp';
  static const resendOtpToPhone = '/api/v1/auth/phone/send-otp';
  static const login = '/api/v1/auth/login';
  static const loginWIthPhone = '/api/v1/auth/phone/login';
  static const registerBorrowerWallet =
      '/api/v1/blockchain/creditor/admin/borrower/register';
  static const registerLenderWallet = '/api/v1/lender/register-lender';
  static const registerMerchantWallet =
      '/api/v1/blockchain/creditor/admin/merchant/authorize';
  static const profile = '/api/v1/auth/profile';
  static const refreshToken = '/api/v1/auth/refresh';
  static const passwordResetOtp = '/api/v1/auth/send-password-reset-otp';
  static const resetPasswordOtp = '/api/v1/auth/reset-password-otp';
  static deleteUser(String userID) => '/api/v1/users/$userID';

  static const availableCredit =
      '/api/v1/blockchain/creditor/borrower/available-credit';
  static borrowerProfile(String publicAddress) =>
      '/api/v1/blockchain/creditor/borrower/profile';
  static const logOut = '/api/v1/auth/logout';
  static const deviceSessions = '/api/v1/users/devices/sessions';
  static deleteDeviceSession(String deviceId) =>
      '/api/v1/users/devices/$deviceId';
  static const updateKycStatus = '/api/v1/kyc/update-status';
  static transactionsHistory(String publicAddress) =>
      '/api/v1/blockchain/creditor/borrower/transactions';

  // Merchant APIs

  static const merchantTransactionHistory =
      '/api/v1/blockchain/creditor/merchant/transactions';
  static const latestMerchantTransaction =
      '/api/v1/blockchain/creditor/merchant/transactions/latest';
  static const merchantProfile = '/api/v1/blockchain/creditor/merchant/profile';
}
