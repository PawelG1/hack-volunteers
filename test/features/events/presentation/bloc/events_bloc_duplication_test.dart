import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hack_volunteers/features/events/domain/entities/volunteer_event.dart';
import 'package:hack_volunteers/features/events/domain/usecases/get_events.dart';
import 'package:hack_volunteers/features/events/domain/usecases/save_interested_event.dart';
import 'package:hack_volunteers/features/events/domain/usecases/save_skipped_event.dart';
import 'package:hack_volunteers/features/events/presentation/bloc/events_bloc.dart';
import 'package:hack_volunteers/features/events/presentation/bloc/events_event.dart';
import 'package:hack_volunteers/core/usecases/usecase.dart';

// Mock classes
class MockGetEvents extends Mock implements GetEvents {}

class MockSaveInterestedEvent extends Mock implements SaveInterestedEvent {}

class MockSaveSkippedEvent extends Mock implements SaveSkippedEvent {}

void main() {
  late EventsBloc bloc;
  late MockGetEvents mockGetEvents;
  late MockSaveInterestedEvent mockSaveInterestedEvent;
  late MockSaveSkippedEvent mockSaveSkippedEvent;

  setUp(() {
    mockGetEvents = MockGetEvents();
    mockSaveInterestedEvent = MockSaveInterestedEvent();
    mockSaveSkippedEvent = MockSaveSkippedEvent();

    bloc = EventsBloc(
      getEvents: mockGetEvents,
      saveInterestedEvent: mockSaveInterestedEvent,
      saveSkippedEvent: mockSaveSkippedEvent,
    );

    // Register fallback values
    registerFallbackValue(const NoParams());
    registerFallbackValue(const SaveInterestedEventParams(eventId: ''));
  });

  tearDown(() {
    bloc.close();
  });

  group('EventsBloc Duplication Prevention Tests', () {
    final testEvents = [
      VolunteerEvent(
        id: 'event-1',
        title: 'Test Event 1',
        description: 'Description 1',
        organization: 'Org 1',
        location: 'Location 1',
        date: DateTime(2024, 1, 15, 10, 0),
        requiredVolunteers: 10,
        categories: const ['education'],
        createdAt: DateTime(2024, 1, 1),
      ),
      VolunteerEvent(
        id: 'event-2',
        title: 'Test Event 2',
        description: 'Description 2',
        organization: 'Org 2',
        location: 'Location 2',
        date: DateTime(2024, 1, 16, 14, 0),
        requiredVolunteers: 5,
        categories: const ['environment'],
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

    test('should prevent duplicate SwipeRight for same event', () async {
      // Arrange
      when(() => mockGetEvents(any())).thenAnswer((_) async => Right(testEvents));
      when(() => mockSaveInterestedEvent(any())).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => const Right(null),
        ),
      );

      // Load events first
      bloc.add(LoadEventsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      // Act - Trigger same swipe right event TWICE rapidly
      bloc.add(const SwipeRightEvent('event-1'));
      bloc.add(const SwipeRightEvent('event-1')); // Duplicate!

      await Future.delayed(const Duration(milliseconds: 200));

      // Assert - saveInterestedEvent should be called ONLY ONCE
      verify(() => mockSaveInterestedEvent(
            const SaveInterestedEventParams(eventId: 'event-1'),
          )).called(1); // Should be exactly 1, not 2
    });

    test('should prevent duplicate SwipeRight when triggered 10 times rapidly',
        () async {
      // Arrange
      when(() => mockGetEvents(any())).thenAnswer((_) async => Right(testEvents));
      when(() => mockSaveInterestedEvent(any())).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => const Right(null),
        ),
      );

      // Load events first
      bloc.add(LoadEventsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      // Act - Trigger same swipe right event 10 TIMES (simulating rapid duplicate bug)
      for (int i = 0; i < 10; i++) {
        bloc.add(const SwipeRightEvent('event-1'));
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Assert - saveInterestedEvent should be called ONLY ONCE despite 10 triggers
      verify(() => mockSaveInterestedEvent(
            const SaveInterestedEventParams(eventId: 'event-1'),
          )).called(1);
    });

    test('should allow SwipeRight for different events', () async {
      // Arrange
      when(() => mockGetEvents(any())).thenAnswer((_) async => Right(testEvents));
      when(() => mockSaveInterestedEvent(any())).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 50),
          () => const Right(null),
        ),
      );

      // Load events first
      bloc.add(LoadEventsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      // Act - Swipe right on two DIFFERENT events
      bloc.add(const SwipeRightEvent('event-1'));
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const SwipeRightEvent('event-2'));

      await Future.delayed(const Duration(milliseconds: 200));

      // Assert - Both should be processed
      verify(() => mockSaveInterestedEvent(
            const SaveInterestedEventParams(eventId: 'event-1'),
          )).called(1);
      verify(() => mockSaveInterestedEvent(
            const SaveInterestedEventParams(eventId: 'event-2'),
          )).called(1);
    });

    test(
        'should allow SwipeRight again after first one completes successfully',
        () async {
      // Arrange
      when(() => mockGetEvents(any())).thenAnswer((_) async => Right(testEvents));
      when(() => mockSaveInterestedEvent(any())).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 50),
          () => const Right(null),
        ),
      );

      // Load events first
      bloc.add(LoadEventsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      // Act - First swipe
      bloc.add(const SwipeRightEvent('event-1'));
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for completion

      // Second swipe on same event (should be allowed after first completes)
      bloc.add(const SwipeRightEvent('event-1'));
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - Should be called TWICE (once per completed swipe)
      verify(() => mockSaveInterestedEvent(
            const SaveInterestedEventParams(eventId: 'event-1'),
          )).called(2);
    });

    test('should block SwipeRight while previous one is still processing',
        () async {
      // Arrange
      int callCount = 0;
      when(() => mockGetEvents(any())).thenAnswer((_) async => Right(testEvents));
      when(() => mockSaveInterestedEvent(any())).thenAnswer(
        (_) async {
          callCount++;
          return Future.delayed(
            const Duration(milliseconds: 200), // Long delay
            () => const Right(null),
          );
        },
      );

      // Load events first
      bloc.add(LoadEventsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      // Act - First swipe (will take 200ms)
      bloc.add(const SwipeRightEvent('event-1'));
      await Future.delayed(const Duration(milliseconds: 20)); // Small delay

      // Second swipe while first is still processing
      bloc.add(const SwipeRightEvent('event-1'));
      await Future.delayed(const Duration(milliseconds: 20));

      // Third swipe while still processing
      bloc.add(const SwipeRightEvent('event-1'));

      await Future.delayed(const Duration(milliseconds: 300)); // Wait for all

      // Assert - Should only process first swipe
      expect(callCount, equals(1));
    });
  });
}
