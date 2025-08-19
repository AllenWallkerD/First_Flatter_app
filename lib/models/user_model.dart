class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String profileImage;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['name']['first'] ?? '',
      lastName: json['name']['last'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['picture']['large'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}