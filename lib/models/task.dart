class Task {
  final String author;
  final String title;
  final String description;
  final String board;
  final String date;
  final String createdAt;
  final bool done;
  final List<dynamic> assign;

  final String docId;

  Task({
    required this.author,
    required this.done,
    required this.board,
    required this.title,
    required this.description,
    required this.assign,
    required this.docId,
    required this.date,
    required this.createdAt,
  });

  factory Task.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return Task(
      author: json?["author"] ?? '',
      title: json?["title"] ?? '',
      description: json?['description'] ?? '',
      board: json?['board'] ?? '',
      assign: json?['assign'] ?? [],
      done: json?['done'] ?? false,
      date: json?['date'] ?? '',
      createdAt: json?['createdAt'] ?? '',
      docId: id,
    );
  }
}
