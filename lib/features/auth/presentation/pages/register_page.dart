import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';

/// Registration page
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole? _selectedRole; // Track selected role

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wybierz typ konta'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      // TODO: Implement registration with BLoC
      AppRouter.setUserRole(_selectedRole);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rejestracja zakończona!'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Navigate to appropriate dashboard
      switch (_selectedRole!) {
        case UserRole.volunteer:
          context.go('/volunteer');
          break;
        case UserRole.organization:
          context.go('/organization');
          break;
        case UserRole.schoolCoordinator:
          context.go('/coordinator');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      iconSize: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_outlined,
                      size: 60,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Utwórz konto',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Register Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Imię i nazwisko',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj imię i nazwisko';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj email';
                              }
                              if (!value.contains('@')) {
                                return 'Nieprawidłowy email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Hasło',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj hasło';
                              }
                              if (value.length < 6) {
                                return 'Hasło musi mieć min. 6 znaków';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password field
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Potwierdź hasło',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Potwierdź hasło';
                              }
                              if (value != _passwordController.text) {
                                return 'Hasła się nie zgadzają';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Account Type Selection
                          const Text(
                            'Typ konta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Role selection chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Text('Wolontariusz'),
                                avatar: const Icon(Icons.volunteer_activism, size: 18),
                                selected: _selectedRole == UserRole.volunteer,
                                selectedColor: AppColors.primaryMagenta.withOpacity(0.2),
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedRole = selected ? UserRole.volunteer : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Organizacja'),
                                avatar: const Icon(Icons.business, size: 18),
                                selected: _selectedRole == UserRole.organization,
                                selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedRole = selected ? UserRole.organization : null;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Koordynator'),
                                avatar: const Icon(Icons.school, size: 18),
                                selected: _selectedRole == UserRole.schoolCoordinator,
                                selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedRole = selected ? UserRole.schoolCoordinator : null;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Register button
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Zarejestruj się',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Masz już konto?',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go('/login');
                                },
                                child: const Text('Zaloguj się'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          
                          // Footer z informacją o wsparciu
                          const MlodyKrakowFooter(
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
