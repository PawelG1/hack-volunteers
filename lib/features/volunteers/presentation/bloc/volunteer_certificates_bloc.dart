import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../../domain/usecases/get_volunteer_certificates.dart';

part 'volunteer_certificates_event.dart';
part 'volunteer_certificates_state.dart';

class VolunteerCertificatesBloc
    extends Bloc<VolunteerCertificatesEvent, VolunteerCertificatesState> {
  final GetVolunteerCertificates getVolunteerCertificates;

  VolunteerCertificatesBloc({
    required this.getVolunteerCertificates,
  }) : super(VolunteerCertificatesInitial()) {
    on<LoadVolunteerCertificates>(_onLoadVolunteerCertificates);
  }

  Future<void> _onLoadVolunteerCertificates(
    LoadVolunteerCertificates event,
    Emitter<VolunteerCertificatesState> emit,
  ) async {
    print('📜 CERT_BLOC: Loading certificates for volunteerId: ${event.volunteerId}');
    emit(VolunteerCertificatesLoading());

    final result = await getVolunteerCertificates(event.volunteerId);

    result.fold(
      (failure) {
        print('❌ CERT_BLOC: Error loading certificates: ${failure.message}');
        emit(VolunteerCertificatesError(failure.message));
      },
      (certificates) {
        print('✅ CERT_BLOC: Loaded ${certificates.length} certificates');
        for (final cert in certificates) {
          print('   - ${cert.organizationName}: ${cert.eventTitle}');
        }
        emit(VolunteerCertificatesLoaded(certificates));
      },
    );
  }
}
