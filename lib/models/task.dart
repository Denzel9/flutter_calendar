class TaskModel {
  final String author;
  final String title;
  final String description;
  final String board;
  final String date;
  final String createdAt;
  final bool done;
  final List<dynamic> assign;
  final String docId;
  final String userId;
  final bool isCollaborated;

  TaskModel({
    required this.author,
    required this.done,
    required this.board,
    required this.title,
    required this.description,
    required this.assign,
    required this.docId,
    required this.date,
    required this.createdAt,
    required this.isCollaborated,
    required this.userId,
  });

  factory TaskModel.fromJsonWithId(Map<String, dynamic>? json, String id) {
    return TaskModel(
      author: json?["author"] ?? '',
      title: json?["title"] ?? '',
      description: json?['description'] ?? '',
      board: json?['board'] ?? '',
      assign: json?['assign'] ?? [],
      done: json?['done'] ?? false,
      date: json?['date'] ?? '',
      createdAt: json?['createdAt'] ?? '',
      isCollaborated: json?['isCollaborated'] ?? false,
      userId: json?['userId'] ?? '',
      docId: id,
    );
  }
}
