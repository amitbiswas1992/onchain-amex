class RegisterDto {
  final String emailOrPhone;
  final String password;
  final String firstName;
  final String lastName;
  final bool isEmail;

  const RegisterDto({
    required this.emailOrPhone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isEmail,
  });

  Map<String, dynamic> toJson() {
    final data = {
      isEmail ? "email" : "phoneNumber": emailOrPhone,
      "password": password,
      "username": firstName.toLowerCase(),
      "firstName": firstName,
      "lastName": lastName
    };
    return data;
  }
}
