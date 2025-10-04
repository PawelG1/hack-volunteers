import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  image,
  file,
  systemNotification, // np. "Wolontariusz został zaakceptowany"
}

/// Wiadomość w czacie
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final MessageType type;
  final String content; // Tekst lub URL do pliku/zdjęcia
  final DateTime sentAt;
  final bool isRead;
  final DateTime? readAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.content,
    required this.sentAt,
    required this.isRead,
    this.readAt,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        type,
        content,
        sentAt,
        isRead,
        readAt,
      ];

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    MessageType? type,
    String? content,
    DateTime? sentAt,
    bool? isRead,
    DateTime? readAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      type: type ?? this.type,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }
}
