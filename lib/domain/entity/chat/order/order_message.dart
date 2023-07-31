import '../../user/user.dart';

class OrderMessage {
  String id;
  String orderConversationId;
  String userId;
  String message;
  int readStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User user;

  OrderMessage({
    required this.id,
    required this.orderConversationId,
    required this.userId,
    required this.message,
    required this.readStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user
  });
}