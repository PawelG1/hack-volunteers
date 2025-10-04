import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/volunteers/presentation/pages/volunteer_dashboard.dart';
import '../../features/organizations/presentation/pages/organization_dashboard.dart';
import '../../features/organizations/presentation/pages/manage_events_page.dart';
import '../../features/organizations/presentation/pages/applications_page.dart';
import '../../features/coordinators/presentation/pages/coordinator_dashboard.dart';

// Export UserRole so other files can use it
export '../../features/auth/domain/entities/user.dart' show UserRole;

/// Routing configuration for the app
class AppRouter {
  // Mock current user - will be replaced with actual auth state
  static UserRole? _currentUserRole;

  static void setUserRole(UserRole? role) {
    _currentUserRole = role;
  }

  static UserRole? getCurrentUserRole() {
    return _currentUserRole;
  }

  static void logout() {
    _currentUserRole = null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Volunteer routes
      GoRoute(
        path: '/volunteer',
        name: 'volunteer',
        builder: (context, state) => const VolunteerDashboard(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'volunteer-profile',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'applications',
            name: 'volunteer-applications',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'certificates',
            name: 'volunteer-certificates',
            builder: (context, state) => const Placeholder(), // TODO
          ),
        ],
      ),

      // Organization routes
      GoRoute(
        path: '/organization',
        name: 'organization',
        builder: (context, state) => const OrganizationDashboard(),
        routes: [
          GoRoute(
            path: 'events',
            name: 'organization-events',
            builder: (context, state) => const ManageEventsPage(),
          ),
          GoRoute(
            path: 'applications',
            name: 'organization-applications',
            builder: (context, state) => const ApplicationsPage(),
          ),
          GoRoute(
            path: 'chat',
            name: 'organization-chat',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'certificates',
            name: 'organization-certificates',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'reports',
            name: 'organization-reports',
            builder: (context, state) => const Placeholder(), // TODO
          ),
        ],
      ),

      // Coordinator routes
      GoRoute(
        path: '/coordinator',
        name: 'coordinator',
        builder: (context, state) => const CoordinatorDashboard(),
        routes: [
          GoRoute(
            path: 'students',
            name: 'coordinator-students',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'certificates',
            name: 'coordinator-certificates',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'calendar',
            name: 'coordinator-calendar',
            builder: (context, state) => const Placeholder(), // TODO
          ),
          GoRoute(
            path: 'reports',
            name: 'coordinator-reports',
            builder: (context, state) => const Placeholder(), // TODO
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';
      
      // If user is not logged in, redirect to login
      if (_currentUserRole == null && !isLoginRoute && !isRegisterRoute) {
        return '/login';
      }

      // If logged in and on login page, redirect to appropriate dashboard
      if (_currentUserRole != null && (isLoginRoute || isRegisterRoute)) {
        switch (_currentUserRole) {
          case UserRole.volunteer:
            return '/volunteer';
          case UserRole.organization:
            return '/organization';
          case UserRole.schoolCoordinator:
            return '/coordinator';
          default:
            return null;
        }
      }

      return null; // No redirect needed
    },
  );
}
