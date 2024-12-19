enum OperationType { coloboration }

class NotificationModel {
  final String author;
  final String title;
  final String createdAt;
  final String userId;
  final String docId;
  final String guestId;
  final String operation;
  final bool isAccepted;

  NotificationModel({
    required this.author,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.docId,
    required this.guestId,
    required this.operation,
    required this.isAccepted,
  });

  factory NotificationModel.fromJsonWithId(
      Map<String, dynamic>? json, String id) {
    return NotificationModel(
      author: json?["author"] ?? '',
      title: json?["title"] ?? '',
      createdAt: json?['createdAt'] ?? '',
      userId: json?['userId'] ?? '',
      guestId: json?['guestId'] ?? '',
      operation: json?['operation'] ?? '',
      isAccepted: json?['isAccepted'] ?? '',
      docId: id,
    );
  }
}
