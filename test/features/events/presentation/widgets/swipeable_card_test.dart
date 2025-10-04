import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hack_volunteers/features/events/domain/entities/volunteer_event.dart';
import 'package:hack_volunteers/features/events/presentation/widgets/swipeable_card.dart';

void main() {
  group('SwipeableCard Duplication Prevention Tests', () {
    late VolunteerEvent testEvent;

    setUp(() {
      testEvent = VolunteerEvent(
        id: 'test-event-123',
        title: 'Test Event',
        description: 'Test Description',
        organization: 'Test Org',
        location: 'Test Location',
        date: DateTime(2024, 1, 15, 10, 0),
        requiredVolunteers: 10,
        categories: const ['education'],
        createdAt: DateTime(2024, 1, 1),
      );
    });

    testWidgets('should trigger onSwipeRight callback only once per swipe',
        (WidgetTester tester) async {
      // Arrange
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SwipeableCard(
                event: testEvent,
                onSwipeLeft: () {},
                onSwipeRight: () {
                  callCount++;
                },
                isFront: true,
              ),
            ),
          ),
        ),
      );

      // Act - Simulate swipe right gesture
      final cardFinder = find.byType(SwipeableCard);
      expect(cardFinder, findsOneWidget);

      // Drag right beyond threshold (30% of screen width)
      await tester.drag(cardFinder, const Offset(400, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(callCount, equals(1), reason: 'Callback should be called exactly once');
    });

    testWidgets('should not trigger callback multiple times if widget rebuilds during animation',
        (WidgetTester tester) async {
      // Arrange
      int callCount = 0;
      final ValueNotifier<int> rebuildTrigger = ValueNotifier(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<int>(
              valueListenable: rebuildTrigger,
              builder: (context, value, child) {
                return Center(
                  child: SwipeableCard(
                    event: testEvent,
                    onSwipeLeft: () {},
                    onSwipeRight: () {
                      callCount++;
                    },
                    isFront: true,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act - Swipe and trigger rebuilds during animation
      final cardFinder = find.byType(SwipeableCard);
      
      // Start drag
      await tester.drag(cardFinder, const Offset(400, 0));
      
      // Trigger rebuilds while animation is running
      rebuildTrigger.value++;
      await tester.pump(const Duration(milliseconds: 50));
      
      rebuildTrigger.value++;
      await tester.pump(const Duration(milliseconds: 50));
      
      rebuildTrigger.value++;
      await tester.pumpAndSettle();

      // Assert - Should still only call once despite rebuilds
      expect(callCount, equals(1), reason: 'Callback should be called once despite rebuilds');
    });

    testWidgets('should not trigger callback if widget is disposed before animation completes',
        (WidgetTester tester) async {
      // Arrange
      int callCount = 0;
      bool showCard = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: showCard
                      ? SwipeableCard(
                          event: testEvent,
                          onSwipeLeft: () {},
                          onSwipeRight: () {
                            callCount++;
                          },
                          isFront: true,
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      );

      // Act - Start drag
      final cardFinder = find.byType(SwipeableCard);
      await tester.drag(cardFinder, const Offset(400, 0));
      
      // Remove widget before animation completes
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: SizedBox()),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Assert - Callback should not be triggered after disposal
      expect(callCount, equals(0), reason: 'Callback should not fire after widget disposal');
    });

    testWidgets('should block second swipe attempt before animation completes',
        (WidgetTester tester) async {
      // Arrange
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SwipeableCard(
                event: testEvent,
                onSwipeLeft: () {},
                onSwipeRight: () {
                  callCount++;
                },
                isFront: true,
              ),
            ),
          ),
        ),
      );

      // Act - First swipe
      final cardFinder = find.byType(SwipeableCard);
      await tester.drag(cardFinder, const Offset(400, 0));
      await tester.pump(const Duration(milliseconds: 50)); // Don't wait for animation to finish
      
      // Try to swipe again while animation is still running
      // Note: This simulates programmatic swipe, in real app gestures are blocked by Flutter
      await tester.drag(cardFinder, const Offset(400, 0));
      await tester.pumpAndSettle();

      // Assert - Should only trigger once
      expect(callCount, equals(1), reason: 'Second swipe during animation should be blocked');
    });

    testWidgets('should allow swipe on different SwipeableCard instances',
        (WidgetTester tester) async {
      // Arrange
      int callCount1 = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: SwipeableCard(
                  key: const Key('card1'),
                  event: testEvent,
                  onSwipeLeft: () {},
                  onSwipeRight: () {
                    callCount1++;
                  },
                  isFront: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Act - Swipe card
      await tester.drag(find.byKey(const Key('card1')), const Offset(400, 0));
      await tester.pumpAndSettle();

      // Assert - Should trigger exactly once
      expect(callCount1, equals(1), reason: 'Card callback should be called once');
    });
  });
}
