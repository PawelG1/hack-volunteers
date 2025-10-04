import 'package:equatable/equatable.dart';

/// Organization type
enum OrganizationType {
  ngo,
  foundation,
  association,
  school,
  company,
  government,
  other,
}

/// Organization profile entity
class Organization extends Equatable {
  final String userId;
  final String name;
  final OrganizationType type;
  final String description;
  final String? nip; // Tax ID
  final String? krs; // National Court Register number
  final String address;
  final String city;
  final String phoneNumber;
  final String? website;
  final List<String> focusAreas; // Obszary działalności
  final int publishedEvents; // Liczba opublikowanych wydarzeń
  final int activeVolunteers; // Liczba aktywnych wolontariuszy
  final double rating; // Średnia ocena od wolontariuszy
  final DateTime verifiedAt; // Data weryfikacji organizacji
  final bool isVerified;

  const Organization({
    required this.userId,
    required this.name,
    required this.type,
    required this.description,
    this.nip,
    this.krs,
    required this.address,
    required this.city,
    required this.phoneNumber,
    this.website,
    this.focusAreas = const [],
    this.publishedEvents = 0,
    this.activeVolunteers = 0,
    this.rating = 0.0,
    required this.verifiedAt,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        type,
        description,
        nip,
        krs,
        address,
        city,
        phoneNumber,
        website,
        focusAreas,
        publishedEvents,
        activeVolunteers,
        rating,
        verifiedAt,
        isVerified,
      ];

  Organization copyWith({
    String? userId,
    String? name,
    OrganizationType? type,
    String? description,
    String? nip,
    String? krs,
    String? address,
    String? city,
    String? phoneNumber,
    String? website,
    List<String>? focusAreas,
    int? publishedEvents,
    int? activeVolunteers,
    double? rating,
    DateTime? verifiedAt,
    bool? isVerified,
  }) {
    return Organization(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      nip: nip ?? this.nip,
      krs: krs ?? this.krs,
      address: address ?? this.address,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      focusAreas: focusAreas ?? this.focusAreas,
      publishedEvents: publishedEvents ?? this.publishedEvents,
      activeVolunteers: activeVolunteers ?? this.activeVolunteers,
      rating: rating ?? this.rating,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
