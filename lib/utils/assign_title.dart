String assignTitle(
  String userId,
  String taskId,
  String name,
) =>
    'Assigned by ${userId == taskId ? 'me' : name}';
