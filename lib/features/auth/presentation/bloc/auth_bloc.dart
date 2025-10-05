import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/volunteer.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  final UserRole role;
  final String? firstName;
  final String? lastName;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [email, password, displayName, role, firstName, lastName];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoadVolunteerProfileEvent extends AuthEvent {}

class UpdateVolunteerProfileEvent extends AuthEvent {
  final Volunteer volunteer;

  UpdateVolunteerProfileEvent(this.volunteer);

  @override
  List<Object?> get props => [volunteer];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final Volunteer? volunteer;

  Authenticated(this.user, [this.volunteer]);

  @override
  List<Object?> get props => [user, volunteer];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoadVolunteerProfileEvent>(_onLoadVolunteerProfile);
    on<UpdateVolunteerProfileEvent>(_onUpdateVolunteerProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    final result = await repository.signIn(
      email: event.email,
      password: event.password,
    );
    
    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (user) async {
        if (user.role == UserRole.volunteer) {
          final volunteer = repository.getVolunteerProfile();
          emit(Authenticated(user, volunteer));
        } else {
          emit(Authenticated(user));
        }
      },
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    if (event.role == UserRole.volunteer) {
      final result = await repository.signUpVolunteer(
        email: event.email,
        password: event.password,
        fullName: event.displayName,
        schoolId: null,
        className: null,
      );
      
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (volunteer) {
          final user = User(
            id: volunteer.userId,
            email: event.email,
            displayName: event.displayName,
            role: UserRole.volunteer,
            createdAt: DateTime.now(),
            isActive: true,
          );
          emit(Authenticated(user, volunteer));
        },
      );
    } else {
      emit(AuthError('Rejestracja tylko dla wolontariuszy jest obecnie wspierana'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final result = await repository.getCurrentUser();
    
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user == null) {
          emit(Unauthenticated());
        } else if (user.role == UserRole.volunteer) {
          final volunteer = repository.getVolunteerProfile();
          emit(Authenticated(user, volunteer));
        } else {
          emit(Authenticated(user));
        }
      },
    );
  }

  Future<void> _onLoadVolunteerProfile(
      LoadVolunteerProfileEvent event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      final currentState = state as Authenticated;
      final volunteer = repository.getVolunteerProfile();
      emit(Authenticated(currentState.user, volunteer));
    }
  }

  Future<void> _onUpdateVolunteerProfile(
      UpdateVolunteerProfileEvent event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      final currentState = state as Authenticated;
      final result = await repository.updateVolunteerProfile(event.volunteer);
      
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (volunteer) => emit(Authenticated(currentState.user, volunteer)),
      );
    }
  }
}
