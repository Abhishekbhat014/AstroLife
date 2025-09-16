// ... imports ...
import 'dart:convert';
import 'package:crypto/crypto.dart'; // Add this import for password hashing
import 'package:astro_life/db/user_dao.dart';
import 'package:astro_life/models/user.dart';
import 'package:astro_life/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  String _gender = 'Male';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final UserDao _userDao = UserDao();

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    int genderValue =
        _gender == 'Male'
            ? 0
            : _gender == 'Female'
            ? 1
            : 2;

    final newUser = User(
      firstName: _firstNameController.text.trim(),
      middleName:
          _middleNameController.text.trim().isEmpty
              ? "-"
              : _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      motherName:
          _motherNameController.text.trim().isEmpty
              ? "-"
              : _motherNameController.text.trim(),
      gender: genderValue,
      dob: _dobController.text.trim(),
      birthPlace:
          _birthPlaceController.text.trim().isEmpty
              ? "-"
              : _birthPlaceController.text.trim(),
      address:
          _addressController.text.trim().isEmpty
              ? "-"
              : _addressController.text.trim(),
      email: _emailController.text.trim(),
      password: _hashPassword(_passwordController.text.trim()),
      contact:
          _contactController.text.trim().isEmpty
              ? "-"
              : _contactController.text.trim(),
      roleId: 1,
    );

    try {
      await _userDao.insertUser(newUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _motherNameController.dispose();
    _dobController.dispose();
    _birthPlaceController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Create Account",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              Text(
                "Let's get started",
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter your details to create an account",
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              _buildModernTextField(
                _firstNameController,
                'First Name',
                'Please enter your first name',
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _middleNameController,
                'Middle Name (Optional)',
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _lastNameController,
                'Last Name',
                'Please enter your last name',
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _motherNameController,
                "Mother's Name",
                "Please enter your mother's name",
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _dobController,
                'Date of Birth (YYYY-MM-DD)',
                'Use YYYY-MM-DD format',
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _birthPlaceController,
                'Birth Place',
                'Please enter your birth place',
              ),
              const SizedBox(height: 16),
              _buildModernGenderDropdown(colorScheme, textTheme),
              const SizedBox(height: 16),
              _buildModernTextField(
                _addressController,
                'Address',
                'Please enter your address',
              ),
              const SizedBox(height: 16),
              _buildModernTextField(
                _emailController,
                'Email',
                'Please enter a valid email',
              ),
              const SizedBox(height: 16),
              _buildModernPasswordField(colorScheme, textTheme),
              const SizedBox(height: 16),
              _buildModernTextField(
                _contactController,
                'Contact Number',
                'Please enter a valid phone number',
              ),
              const SizedBox(height: 40),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _registerUser,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Text(
                  "Already have an account? Sign In",
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for the modern text field design
  Widget _buildModernTextField(
    TextEditingController controller,
    String labelText, [
    String? validationText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (validationText != null && (value == null || value.trim().isEmpty)) {
          return validationText;
        }
        return null;
      },
    );
  }

  // Helper method for the modern password field
  Widget _buildModernPasswordField(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter Password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  // Helper method for the modern gender dropdown
  Widget _buildModernGenderDropdown(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _gender,
          dropdownColor: colorScheme.surface,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _gender = value);
          },
        ),
      ),
    );
  }
}
