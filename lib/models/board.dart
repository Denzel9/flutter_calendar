class Board {
  final String author;
  final String title;
  final String description;
  final String createdAt;
  final String userId;
  final String docId;
  final List<dynamic> tasks;

  Board({
    required this.author,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.docId,
    required this.tasks,
  });

  factory Board.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return Board(
      author: json?["author"] ?? '',
      title: json?["title"] ?? '',
      description: json?['description'] ?? '',
      createdAt: json?['createdAt'] ?? '',
      userId: json?['userId'] ?? '',
      tasks: json?['tasks'] ?? [],
      docId: id,
    );
  }
}
