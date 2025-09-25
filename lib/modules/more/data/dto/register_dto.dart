class RegisterDto {
  final String emailOrPhone;
  final String password;
  final String firstName;
  final String lastName;
  final bool isEmail;
  final String userType;

  const RegisterDto({
    required this.emailOrPhone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isEmail,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    final data = {
      isEmail ? "email" : "phoneNumber": emailOrPhone,
      "password": password,
      "username": DateTime.now().millisecondsSinceEpoch.toString(),
      "firstName": firstName,
      "lastName": lastName,
      "userType": userType,
    };
    return data;
  }
}
