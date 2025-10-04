import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

/// Repository for chat operations
abstract class ChatRepository {
  /// Get all conversations for user
  Future<Either<Failure, List<Conversation>>> getUserConversations(
      String userId);

  /// Get conversation by ID
  Future<Either<Failure, Conversation>> getConversation(String conversationId);

  /// Create new conversation
  Future<Either<Failure, Conversation>> createConversation({
    required List<String> participantIds,
    String? eventId,
  });

  /// Send message
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    String? imageUrl,
    String? fileUrl,
  });

  /// Get messages for conversation
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int? limit,
    DateTime? before,
  });

  /// Mark message as read
  Future<Either<Failure, void>> markMessageAsRead(String messageId);

  /// Mark all messages in conversation as read
  Future<Either<Failure, void>> markConversationAsRead({
    required String conversationId,
    required String userId,
  });

  /// Get messages stream (real-time updates)
  Stream<List<Message>> getMessagesStream(String conversationId);

  /// Get conversations stream (real-time updates)
  Stream<List<Conversation>> getConversationsStream(String userId);
}
