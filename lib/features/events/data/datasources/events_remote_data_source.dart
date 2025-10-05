import '../models/volunteer_event_model.dart';

/// Abstract interface for remote data source
/// Will be implemented with Firebase later
abstract class EventsRemoteDataSource {
  /// Fetch events from remote server
  Future<List<VolunteerEventModel>> getEvents();
}

/// Mock implementation with dummy data
class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  @override
  Future<List<VolunteerEventModel>> getEvents() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data
    return [
      VolunteerEventModel(
        id: '1',
        title: 'Sprzątanie parku miejskiego',
        description:
            'Pomóż nam posprzątać park miejski! Będziemy zbierać śmieci, grabić liście i dbać o czystość naszego wspólnego miejsca.',
        organization: 'Zielone Miasto',
        location: 'Park Centralny, Kraków',
        latitude: 50.0647,
        longitude: 19.9450,
        date: DateTime.now().add(const Duration(days: 7)),
        requiredVolunteers: 15,
        categories: ['Środowisko', 'Społeczność lokalna'],
        imageUrl: 'assets/images/events/3.png',
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '2',
        title: 'Pomoc w schronisku dla zwierząt',
        description:
            'Poszukujemy wolontariuszy do pomocy w schronisku. Zadania obejmują spacery z psami, karmienie zwierząt i sprzątanie wybiegów.',
        organization: 'Schronisko Cztery Łapy',
        location: 'ul. Zwierzęca 15, Kraków',
        latitude: 50.0213,
        longitude: 19.9384,
        date: DateTime.now().add(const Duration(days: 3)),
        requiredVolunteers: 8,
        categories: ['Zwierzęta', 'Opieka'],
        imageUrl: 'assets/images/events/4.png',
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '3',
        title: 'Spotkanie międzypokoleniowe - DIY z przedszkolakami i seniorami',
        description:
            'Wyjątkowe wydarzenie łączące pokolenia! Dzieci z przedszkola i seniorzy spotkają się, aby wspólnie tworzyć ozdoby DIY, malować obrazki i wykonywać proste prace ręczne. To doskonała okazja do wymiany doświadczeń, rozwijania kreatywności i budowania więzi międzypokoleniowych. Aktywizacja obu grup w przyjaznej, rodzinnej atmosferze.',
        organization: 'Fundacja Most Pokoleń',
        location: 'Dom Kultury Podgórze, Kraków',
        latitude: 50.0337,
        longitude: 19.9632,
        date: DateTime.now().add(const Duration(days: 14)),
        requiredVolunteers: 8,
        categories: ['Edukacja', 'Pomoc społeczna', 'Kultura'],
        imageUrl: 'assets/images/events/1.png',
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '4',
        title: 'Warsztaty składania dronów FPV dla Obrony Cywilnej',
        description:
            'Praktyczne szkolenie z montażu dronów FPV przeznaczonych dla Obrony Cywilnej. Uczestnicy nauczą się podstaw składania dronów, konfiguracji komponentów i przygotowania sprzętu do działań wspierających służby ratunkowe. Nie jest wymagane doświadczenie techniczne - wszystkiego nauczymy na miejscu. Twój czas pomoże wzmocnić bezpieczeństwo lokalne!',
        organization: 'TechVolunteers dla OC',
        location: 'Laboratorium Techniczne AGH, Kraków',
        latitude: 50.0665,
        longitude: 19.9182,
        date: DateTime.now().add(const Duration(days: 5)),
        requiredVolunteers: 12,
        categories: ['Technologia', 'Pomoc społeczna', 'Edukacja'],
        imageUrl: 'assets/images/events/5.png',
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '5',
        title: 'Koncert Charytatywny - Pomoc Dzieciom z Domów Dziecka',
        description:
            'Wspólnie organizujemy wielki koncert charytatywny, którego cały dochód trafi do dzieci z lokalnych domów dziecka. Poszukujemy wolontariuszy do pomocy przy organizacji: obsługa wejścia, sprzedaż biletów, pomoc techniczna, koordynacja gości. Wystąpią lokalni artyści i zespoły młodzieżowe. Dołącz do nas i spraw, by muzyka niosła pomoc!',
        organization: 'Fundacja Muzyka dla Dobra',
        location: 'Filharmonia Krakowska, Kraków',
        latitude: 50.0640,
        longitude: 19.9464,
        date: DateTime.now().add(const Duration(days: 21)),
        requiredVolunteers: 25,
        categories: ['Kultura', 'Pomoc społeczna', 'Muzyka'],
        imageUrl: 'assets/images/events/2.png',
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '6',
        title: 'Sadzenie drzew w Lesie Wolskim',
        description:
            'Akcja sadzenia drzew w Lesie Wolskim. Pomożemy odtworzyć zniszczone fragmenty lasu i walczyć ze zmianami klimatu.',
        organization: 'Las Nadziei',
        location: 'Las Wolski, Kraków',
        latitude: 50.0780,
        longitude: 19.8850,
        date: DateTime.now().add(const Duration(days: 10)),
        requiredVolunteers: 30,
        categories: ['Środowisko', 'Przyroda'],
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '7',
        title: 'Zajęcia komputerowe dla seniorów',
        description:
            'Pomóż seniorom nauczyć się obsługi komputera i internetu. Podstawy maila, videorozmów i mediów społecznościowych.',
        organization: 'Cyfrowi Seniorzy',
        location: 'Centrum Seniora, ul. Krakowska 50',
        latitude: 50.0560,
        longitude: 19.9310,
        date: DateTime.now().add(const Duration(days: 4)),
        requiredVolunteers: 5,
        categories: ['Edukacja', 'Technologia'],
        createdAt: DateTime.now(),
      ),

    ];
  }
}
