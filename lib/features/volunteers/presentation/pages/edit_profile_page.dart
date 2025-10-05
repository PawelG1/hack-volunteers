import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../domain/entities/volunteer_profile.dart';
import '../../data/services/profile_storage_service.dart';

/// Page for editing volunteer profile
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jan Kowalski');
  final _emailController = TextEditingController(text: 'jan.kowalski@example.com');
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _schoolController = TextEditingController();
  final _profileStorage = ProfileStorageService();
  
  File? _profileImage;
  DateTime? _birthDate;
  String _selectedGender = 'Nie podano';
  final List<String> _selectedInterests = [];
  bool _isLoading = false;
  
  final List<String> _availableInterests = [
    'Środowisko',
    'Edukacja',
    'Sport',
    'Kultura',
    'Technologia',
    'Zdrowie',
    'Zwierzęta',
    'Pomoc społeczna',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    
    try {
      final profile = await _profileStorage.loadProfile();
      
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _phoneController.text = profile.phone ?? '';
          _bioController.text = profile.bio ?? '';
          _schoolController.text = profile.school ?? '';
          _birthDate = profile.birthDate;
          _selectedGender = profile.gender;
          _selectedInterests.clear();
          _selectedInterests.addAll(profile.interests);
          
          if (profile.profileImagePath != null) {
            _profileImage = File(profile.profileImagePath!);
          }
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = _birthDate ?? DateTime(now.year - 18, now.month, now.day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMagenta,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final profile = VolunteerProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim().isNotEmpty 
              ? _phoneController.text.trim() 
              : null,
          bio: _bioController.text.trim().isNotEmpty 
              ? _bioController.text.trim() 
              : null,
          school: _schoolController.text.trim().isNotEmpty 
              ? _schoolController.text.trim() 
              : null,
          birthDate: _birthDate,
          gender: _selectedGender,
          interests: List.from(_selectedInterests),
          profileImagePath: _profileImage?.path,
        );
        
        await _profileStorage.saveProfile(profile);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil zapisany pomyślnie!'),
              backgroundColor: AppColors.primaryGreen,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate changes were saved
        }
      } catch (e) {
        print('Error saving profile: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd zapisywania profilu: $e'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj profil'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Zapisz',
              style: TextStyle(
                color: AppColors.primaryMagenta,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryMagenta.withOpacity(0.1),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.primaryMagenta,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryMagenta,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Info Section
              _buildSectionTitle('Informacje osobiste'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Imię i nazwisko *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać imię i nazwisko';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę podać email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Nieprawidłowy format email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                  helperText: 'Opcjonalne',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Birth Date
              InkWell(
                onTap: _selectBirthDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data urodzenia',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  child: Text(
                    _birthDate != null
                        ? '${_birthDate!.day}.${_birthDate!.month}.${_birthDate!.year}'
                        : 'Wybierz datę',
                    style: TextStyle(
                      color: _birthDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Płeć',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc_outlined),
                ),
                items: ['Nie podano', 'Kobieta', 'Mężczyzna', 'Inna']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value ?? 'Nie podano';
                  });
                },
              ),
              const SizedBox(height: 24),

              // Bio Section
              _buildSectionTitle('O mnie'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Opisz siebie',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                  helperText: 'Opcjonalne',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Education Section
              _buildSectionTitle('Edukacja'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(
                  labelText: 'Szkoła/Uczelnia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school_outlined),
                  helperText: 'Opcjonalne',
                ),
              ),
              const SizedBox(height: 24),

              // Interests Section
              _buildSectionTitle('Zainteresowania'),
              const SizedBox(height: 8),
              Text(
                'Wybierz swoje zainteresowania (pomoże to w dopasowaniu wydarzeń)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryMagenta.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryMagenta,
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryMagenta : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryMagenta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Zapisz zmiany',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}
