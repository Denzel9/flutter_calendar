class UserModel {
  String name;
  String lastName;
  String email;
  String? docId;
  String? about;
  String? avatar;
  List<dynamic> following;
  List<dynamic> followers;

  UserModel({
    required this.name,
    required this.lastName,
    required this.email,
    required this.following,
    required this.followers,
    this.avatar,
    this.docId,
    this.about,
  });

  factory UserModel.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return UserModel(
      email: json?["email"] ?? '',
      name: json?['name'] ?? '',
      lastName: json?['lastName'] ?? '',
      following: json?['following'] ?? [],
      followers: json?['followers'] ?? [],
      about: json?['about'] ?? '',
      avatar: json?["avatar"] ?? '',
      docId: id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      'name': name,
      'lastName': lastName,
      'following': following,
      'followers': followers,
      'about': about,
      'avatar': avatar,
      'docId': docId
    };
  }
}
