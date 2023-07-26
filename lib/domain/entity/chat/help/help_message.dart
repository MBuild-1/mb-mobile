import '../../user/user.dart';

class HelpMessage {
  String id;
  String helpConversationId;
  String userId;
  String message;
  int readStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User user;

  HelpMessage({
    required this.id,
    required this.helpConversationId,
    required this.userId,
    required this.message,
    required this.readStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user
  });
}