part of 'volunteer_certificates_bloc.dart';

abstract class VolunteerCertificatesState extends Equatable {
  const VolunteerCertificatesState();

  @override
  List<Object?> get props => [];
}

class VolunteerCertificatesInitial extends VolunteerCertificatesState {}

class VolunteerCertificatesLoading extends VolunteerCertificatesState {}

class VolunteerCertificatesLoaded extends VolunteerCertificatesState {
  final List<Certificate> certificates;

  const VolunteerCertificatesLoaded(this.certificates);

  @override
  List<Object?> get props => [certificates];
}

class VolunteerCertificatesError extends VolunteerCertificatesState {
  final String message;

  const VolunteerCertificatesError(this.message);

  @override
  List<Object?> get props => [message];
}
