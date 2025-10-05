import 'package:isar/isar.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/data/models/certificate_model.dart';
import '../../../organizations/data/models/volunteer_application_model.dart';

/// Local data source for volunteer operations
abstract class VolunteerLocalDataSource {
  /// Get certificates for a volunteer
  Future<List<Certificate>> getVolunteerCertificates(String volunteerId);

  /// Get applications for a volunteer
  Future<List<VolunteerApplication>> getVolunteerApplications(String volunteerId);

  /// Get volunteer statistics
  Future<Map<String, dynamic>> getVolunteerStatistics(String volunteerId);
}

class VolunteerLocalDataSourceImpl implements VolunteerLocalDataSource {
  final Isar isar;

  VolunteerLocalDataSourceImpl({required this.isar});

  @override
  Future<List<Certificate>> getVolunteerCertificates(String volunteerId) async {
    try {
      print('📜 VOLUNTEER_DS: Getting certificates for volunteerId: $volunteerId');
      
      // SEED SAMPLE CERTIFICATES IF NONE EXIST
      final existingCount = await isar.certificateModels.count();
      print('📜 VOLUNTEER_DS: Found $existingCount total certificates in DB');
      
      if (existingCount == 0) {
        print('🌱 VOLUNTEER_DS: No certificates found, creating 2 sample certificates...');
        await _seedSampleCertificates(volunteerId);
      }
      
      // Get certificates directly by volunteerId
      final certificates = await isar.certificateModels
          .filter()
          .volunteerIdEqualTo(volunteerId)
          .findAll();
      
      print('📜 VOLUNTEER_DS: Found ${certificates.length} certificates for volunteer');
      for (final cert in certificates) {
        print('   - ${cert.organizationName}: ${cert.eventTitle} (${cert.hoursWorked}h)');
      }

      return certificates.map((model) => model.toEntity()).toList();
    } catch (e) {
      print('❌ VOLUNTEER_DS: Error getting certificates: $e');
      throw Exception('Failed to get volunteer certificates: $e');
    }
  }
  
  Future<void> _seedSampleCertificates(String volunteerId) async {
    await isar.writeTxn(() async {
      // Certyfikat 1: Schronisko dla zwierząt
      final cert1 = CertificateModel()
        ..certificateId = 'cert_sample_001_${DateTime.now().millisecondsSinceEpoch}'
        ..volunteerId = volunteerId
        ..organizationId = 'org_schronisko_paluchy'
        ..organizationName = 'Schronisko na Paluchu'
        ..eventId = 'event_shelter_001'
        ..eventTitle = 'Pomoc w schronisku - spacery z psami'
        ..eventDate = DateTime(2024, 9, 15)
        ..volunteerName = 'Jan Kowalski'
        ..hoursWorked = 4
        ..description = 'Wolontariusz pomagał w opiece nad zwierzętami: spacery z psami, karmienie, sprzątanie boksów. Wykazał się dużym zaangażowaniem i odpowiedzialnością.'
        ..skills = 'Praca z zwierzętami, odpowiedzialność, punktualność'
        ..status = CertificateStatus.issued
        ..createdAt = DateTime(2024, 9, 16)
        ..approvedAt = DateTime(2024, 9, 17)
        ..approvedBy = 'Koordynator Anna Nowak'
        ..issuedAt = DateTime(2024, 9, 17)
        ..certificateNumber = 'CERT-2024-09-001'
        ..schoolCoordinatorId = 'coord_school_001';
      
      // Certyfikat 2: Pomoc seniorom
      final cert2 = CertificateModel()
        ..certificateId = 'cert_sample_002_${DateTime.now().millisecondsSinceEpoch}'
        ..volunteerId = volunteerId
        ..organizationId = 'org_caritas_krakow'
        ..organizationName = 'Caritas Archidiecezji Krakowskiej'
        ..eventId = 'event_seniors_001'
        ..eventTitle = 'Zakupy i spacery z seniorami'
        ..eventDate = DateTime(2024, 10, 1)
        ..volunteerName = 'Jan Kowalski'
        ..hoursWorked = 5
        ..description = 'Wolontariusz pomagał osobom starszym w codziennych czynnościach: robienie zakupów, spacery, rozmowy. Okazał empatię i cierpliwość w kontakcie z podopiecznymi.'
        ..skills = 'Komunikacja interpersonalna, empatia, pomoc osobom starszym'
        ..status = CertificateStatus.issued
        ..createdAt = DateTime(2024, 10, 2)
        ..approvedAt = DateTime(2024, 10, 3)
        ..approvedBy = 'Koordynator Anna Nowak'
        ..issuedAt = DateTime(2024, 10, 3)
        ..certificateNumber = 'CERT-2024-10-002'
        ..schoolCoordinatorId = 'coord_school_001';
      
      await isar.certificateModels.put(cert1);
      await isar.certificateModels.put(cert2);
      
      print('🌱 VOLUNTEER_DS: Created 2 sample certificates:');
      print('   📜 Schronisko na Paluchu (4h, wrzesień 2024)');
      print('   📜 Caritas Archidiecezji Krakowskiej (5h, październik 2024)');
    });
  }

  @override
  Future<List<VolunteerApplication>> getVolunteerApplications(
      String volunteerId) async {
    try {
      final applications = await isar.volunteerApplicationModels
          .filter()
          .volunteerIdEqualTo(volunteerId)
          .sortByAppliedAtDesc()
          .findAll();

      return applications.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get volunteer applications: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getVolunteerStatistics(
      String volunteerId) async {
    try {
      final applications = await isar.volunteerApplicationModels
          .filter()
          .volunteerIdEqualTo(volunteerId)
          .findAll();

      // Calculate statistics
      final totalApplications = applications.length;
      final acceptedApplications =
          applications.where((app) => app.status == ApplicationStatus.accepted).length;
      final completedApplications =
          applications.where((app) => app.status == ApplicationStatus.completed).length;

      // Calculate total hours
      int totalHours = 0;
      for (final app in applications) {
        if (app.hoursWorked != null) {
          totalHours += app.hoursWorked!;
        }
      }

      // Calculate average rating
      final ratedApplications =
          applications.where((app) => app.rating != null).toList();
      double averageRating = 0.0;
      if (ratedApplications.isNotEmpty) {
        final totalRating = ratedApplications.fold<double>(
            0.0, (sum, app) => sum + app.rating!);
        averageRating = totalRating / ratedApplications.length;
      }

      // Get certificates count
      final certificatesCount =
          applications.where((app) => app.certificateId != null).length;

      return {
        'totalApplications': totalApplications,
        'acceptedApplications': acceptedApplications,
        'completedApplications': completedApplications,
        'totalHours': totalHours,
        'averageRating': averageRating,
        'certificatesCount': certificatesCount,
      };
    } catch (e) {
      throw Exception('Failed to get volunteer statistics: $e');
    }
  }
}
