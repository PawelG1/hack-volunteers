part of 'volunteer_certificates_bloc.dart';

abstract class VolunteerCertificatesEvent extends Equatable {
  const VolunteerCertificatesEvent();

  @override
  List<Object?> get props => [];
}

class LoadVolunteerCertificates extends VolunteerCertificatesEvent {
  final String volunteerId;

  const LoadVolunteerCertificates({required this.volunteerId});

  @override
  List<Object?> get props => [volunteerId];
}
