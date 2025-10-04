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
        date: DateTime.now().add(const Duration(days: 7)),
        requiredVolunteers: 15,
        categories: ['Środowisko', 'Społeczność lokalna'],
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '2',
        title: 'Pomoc w schronisku dla zwierząt',
        description:
            'Poszukujemy wolontariuszy do pomocy w schronisku. Zadania obejmują spacery z psami, karmienie zwierząt i sprzątanie wybiegów.',
        organization: 'Schronisko Cztery Łapy',
        location: 'ul. Zwierzęca 15, Kraków',
        date: DateTime.now().add(const Duration(days: 3)),
        requiredVolunteers: 8,
        categories: ['Zwierzęta', 'Opieka'],
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '3',
        title: 'Warsztaty dla dzieci ze świetlicy',
        description:
            'Organizujemy warsztaty artystyczne dla dzieci. Potrzebujemy osób, które pomogą w prowadzeniu zajęć, przygotowaniu materiałów i opiece nad uczestnikami.',
        organization: 'Fundacja Uśmiech Dziecka',
        location: 'Świetlica Środowiskowa, Kraków',
        date: DateTime.now().add(const Duration(days: 14)),
        requiredVolunteers: 6,
        categories: ['Edukacja', 'Kultura'],
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '4',
        title: 'Zbiórka żywności dla potrzebujących',
        description:
            'Pomóż nam w organizacji zbiórki żywności. Będziemy przyjmować dary, sortować produkty i pakować paczki dla rodzin w trudnej sytuacji.',
        organization: 'Bank Żywności',
        location: 'Magazyn przy ul. Solidarności, Kraków',
        date: DateTime.now().add(const Duration(days: 5)),
        requiredVolunteers: 20,
        categories: ['Pomoc społeczna'],
        createdAt: DateTime.now(),
      ),
      VolunteerEventModel(
        id: '5',
        title: 'Pomoc seniorom - zakupy i rozmowy',
        description:
            'Program wsparcia dla samotnych seniorów. Wolontariusze pomagają w robieniu zakupów, spacerach i spędzają czas na rozmowach.',
        organization: 'Srebrna Jesień',
        location: 'Różne lokalizacje w Krakowie',
        date: DateTime.now().add(const Duration(days: 2)),
        requiredVolunteers: 10,
        categories: ['Zdrowie', 'Pomoc społeczna'],
        createdAt: DateTime.now(),
      ),
    ];
  }
}
