class User {
  String name;
  String lastName;
  String email;
  String docId;
  String aboutUser;

  List<dynamic> following;
  List<dynamic> followers;
  List<dynamic> colaborated;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.docId,
    required this.following,
    required this.followers,
    required this.colaborated,
    required this.aboutUser,
  });

  factory User.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return User(
      email: json?["email"] ?? '',
      name: json?['name'] ?? '',
      lastName: json?['lastName'] ?? '',
      following: json?['following'] ?? [],
      followers: json?['followers'] ?? [],
      colaborated: json?['colaborated'] ?? [],
      aboutUser: json?['aboutUser'] ?? '',
      docId: id,
    );
  }
}
