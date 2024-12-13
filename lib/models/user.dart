class User {
  String name;
  String lastName;
  String email;
  String docId;

  List<dynamic> following;
  List<dynamic> followers;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.docId,
    required this.following,
    required this.followers,
  });

  factory User.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return User(
      email: json?["email"] ?? '',
      name: json?['name'] ?? '',
      lastName: json?['lastName'] ?? '',
      following: json?['following'] ?? [],
      followers: json?['followers'] ?? [],
      docId: id,
    );
  }
}
