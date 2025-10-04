import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';
import '../widgets/swipeable_card.dart';

/// Main screen for swiping through events
class EventsSwipeScreen extends StatelessWidget {
  const EventsSwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Wolontariat dla Ciebie'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EventsInitial) {
            // Load events on init
            context.read<EventsBloc>().add(LoadEventsEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EventsBloc>().add(LoadEventsEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Spróbuj ponownie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is EventsLoaded) {
            final currentEvent = state.currentEvent;

            if (currentEvent == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Obejrzałeś wszystkie wydarzenia!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<EventsBloc>().add(LoadEventsEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Załaduj ponownie'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '${state.currentIndex + 1} / ${state.events.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (state.currentIndex + 1) / state.events.length,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Swipeable card stack
                Expanded(
                  child: Stack(
                    children: [
                      // Background card (next event preview)
                      if (state.currentIndex + 1 < state.events.length)
                        Positioned.fill(
                          child: SwipeableCard(
                            key: ValueKey(
                              'background_${state.events[state.currentIndex + 1].id}',
                            ),
                            event: state.events[state.currentIndex + 1],
                            onSwipeLeft: () {},
                            onSwipeRight: () {},
                            isFront: false,
                          ),
                        ),

                      // Front card (current event)
                      Positioned.fill(
                        child: SwipeableCard(
                          key: ValueKey('front_${currentEvent.id}'),
                          event: currentEvent,
                          onSwipeLeft: () {
                            context.read<EventsBloc>().add(
                              SwipeLeftEvent(currentEvent.id),
                            );
                          },
                          onSwipeRight: () {
                            context.read<EventsBloc>().add(
                              SwipeRightEvent(currentEvent.id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Dislike button
                      FloatingActionButton(
                        heroTag: 'dislike',
                        onPressed: () {
                          context.read<EventsBloc>().add(
                            SwipeLeftEvent(currentEvent.id),
                          );
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 32,
                          color: Colors.red.shade400,
                        ),
                      ),

                      // Like button
                      FloatingActionButton(
                        heroTag: 'like',
                        onPressed: () {
                          context.read<EventsBloc>().add(
                            SwipeRightEvent(currentEvent.id),
                          );
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          size: 32,
                          color: Colors.green.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
