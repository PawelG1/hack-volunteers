import 'package:isar/isar.dart';
import '../../features/organizations/data/models/certificate_model.dart';
import '../../features/organizations/data/models/volunteer_application_model.dart';
import '../../features/organizations/domain/entities/certificate.dart';
import '../../features/organizations/domain/entities/volunteer_application.dart';

/// Seed initial data for testing/demo purposes
class SeedData {
  static Future<void> seedCertificates(Isar isar) async {
    print('🌱 SEED: Checking if certificates need to be seeded...');
    
    // Check if certificates already exist
    final existingCerts = await isar.certificateModels
        .filter()
        .volunteerIdEqualTo('current-volunteer-id')
        .findAll();
    
    if (existingCerts.isNotEmpty) {
      print('🌱 SEED: Found ${existingCerts.length} existing certificates for current-volunteer-id, skipping seed');
      return;
    }
    
    print('🌱 SEED: No certificates found for current-volunteer-id, creating sample certificates...');
    
    await isar.writeTxn(() async {
      // Certyfikat 1: Pomoc w schronisku dla zwierząt
      final cert1 = CertificateModel()
        ..certificateId = 'cert_sample_001'
        ..volunteerId = 'current-volunteer-id' // ID używane w volunteer_dashboard
        ..organizationId = 'org_schronisko_paluchy'
        ..organizationName = 'Schronisko na Paluchu'
        ..eventId = 'event_shelter_001'
        ..eventTitle = 'Pomoc w schronisku - spacery z psami'
        ..eventDate = DateTime(2024, 9, 15)
        ..volunteerName = 'Jan Kowalski' // TODO: Get from volunteer profile
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
        ..certificateId = 'cert_sample_002'
        ..volunteerId = 'current-volunteer-id'
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
      
      print('🌱 SEED: Created 2 sample certificates for volunteer "current-volunteer-id"');
      print('   📜 Certificate 1: Schronisko na Paluchu (4h)');
      print('   📜 Certificate 2: Caritas Archidiecezji Krakowskiej (5h)');
    });
  }
  
  static Future<void> seedTestApplications(Isar isar) async {
    print('🌱 SEED: Checking if test applications need to be seeded...');
    
    // Check if applications already exist for sample-org
    final existingApps = await isar.volunteerApplicationModels
        .filter()
        .organizationIdEqualTo('sample-org')
        .findAll();
    
    if (existingApps.isNotEmpty) {
      print('🌱 SEED: Found ${existingApps.length} existing applications for sample-org, skipping seed');
      return;
    }
    
    print('🌱 SEED: Creating 2 test applications for sample-org...');
    
    await isar.writeTxn(() async {
      final now = DateTime.now();
      
      // Aplikacja 1: Pending
      final app1 = VolunteerApplicationModel()
        ..applicationId = 'app_test_001_${now.millisecondsSinceEpoch}'
        ..eventId = 'test_event_001'
        ..volunteerId = 'volunteer_jan_kowalski'
        ..organizationId = 'sample-org'
        ..status = ApplicationStatus.pending
        ..message = 'Bardzo chciałbym wziąć udział w tym wydarzeniu. Mam doświadczenie w pracy z dziećmi.'
        ..appliedAt = now.subtract(const Duration(days: 2));
      
      // Aplikacja 2: Accepted
      final app2 = VolunteerApplicationModel()
        ..applicationId = 'app_test_002_${now.millisecondsSinceEpoch}'
        ..eventId = 'test_event_002'
        ..volunteerId = 'volunteer_anna_nowak'
        ..organizationId = 'sample-org'
        ..status = ApplicationStatus.accepted
        ..message = 'Jestem bardzo zainteresowana pomocą w organizacji tego wydarzenia.'
        ..appliedAt = now.subtract(const Duration(days: 3))
        ..respondedAt = now.subtract(const Duration(days: 1));
      
      await isar.volunteerApplicationModels.put(app1);
      await isar.volunteerApplicationModels.put(app2);
      
      print('🌱 SEED: Created 2 test applications:');
      print('   📝 Application 1: Jan Kowalski (PENDING)');
      print('   📝 Application 2: Anna Nowak (ACCEPTED)');
    });
  }
}

