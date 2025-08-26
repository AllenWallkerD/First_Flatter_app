class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;
  final String? phone;
  final String? location;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    this.phone,
    this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? {};
    final picture = json['picture'] ?? {};
    final location = json['location'] ?? {};
    
    return UserProfile(
      id: json['login']?['uuid'] ?? '',
      fullName: '${name['first'] ?? ''} ${name['last'] ?? ''}'.trim(),
      email: json['email'] ?? '',
      profileImage: picture['large'] ?? picture['medium'] ?? picture['thumbnail'] ?? '',
      phone: json['phone'],
      location: location['city'] != null && location['country'] != null 
          ? '${location['city']}, ${location['country']}'
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'phone': phone,
      'location': location,
    };
  }

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImage,
    String? phone,
    String? location,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.phone == phone &&
        other.location == location;
  }

  @override
  int get hashCode {
    return Object.hash(id, fullName, email, profileImage, phone, location);
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, profileImage: $profileImage, phone: $phone, location: $location)';
  }
}
