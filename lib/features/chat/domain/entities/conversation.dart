import 'package:equatable/equatable.dart';

/// Rozmowa między użytkownikami (wolontariusz <-> organizacja, koordynator <-> organizacja, itp.)
class Conversation extends Equatable {
  final String id;
  final List<String> participantIds; // IDs uczestników konwersacji
  final String? eventId; // Opcjonalne: rozmowa o konkretnym evencie
  final String lastMessage;
  final DateTime lastMessageTime;
  final Map<String, int> unreadCount; // userId -> liczba nieprzeczytanych wiadomości
  final DateTime createdAt;
  final bool isActive;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.eventId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.createdAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        participantIds,
        eventId,
        lastMessage,
        lastMessageTime,
        unreadCount,
        createdAt,
        isActive,
      ];

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    String? eventId,
    String? lastMessage,
    DateTime? lastMessageTime,
    Map<String, int>? unreadCount,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      eventId: eventId ?? this.eventId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
