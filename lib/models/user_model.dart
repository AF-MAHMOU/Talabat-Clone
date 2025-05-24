class AppUser {
  final String uid;
  final String name;
  final String email;
  final String country;
  final int points;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.country,
    required this.points,
    this.isAdmin = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      country: map['country'] ?? '',
      points: map['points'] ?? 0,
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'country': country,
      'points': points,
      'isAdmin': isAdmin,
    };
  }
}
