class User {
  final String firstName;
  final String lastName;
  String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.password,
  });
}

final Map<String, User> userDatabase = {};
