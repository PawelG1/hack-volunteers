import 'package:equatable/equatable.dart';

enum NotificationType {
  applicationAccepted, // Aplikacja zaakceptowana
  applicationRejected, // Aplikacja odrzucona
  eventReminder, // Przypomnienie o evencie
  certificateIssued, // Certyfikat wystawiony
  certificateApproved, // Certyfikat zatwierdzony przez koordynatora
  certificateRejected, // Certyfikat odrzucony
  newMessage, // Nowa wiadomość w czacie
  eventCancelled, // Event odwołany
  eventUpdated, // Event zaktualizowany
}

/// Powiadomienie dla użytkownika
class AppNotification extends Equatable {
  final String id;
  final String userId; // Odbiorca powiadomienia
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? data; // Dodatkowe dane (eventId, applicationId, itp.)
  final DateTime createdAt;
  final bool isRead;
  final DateTime? readAt;
  final String? actionUrl; // Deep link do konkretnego ekranu

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.createdAt,
    required this.isRead,
    this.readAt,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        message,
        data,
        createdAt,
        isRead,
        readAt,
        actionUrl,
      ];

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isRead,
    DateTime? readAt,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
