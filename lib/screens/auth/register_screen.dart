import 'package:astro_life/models/user_model.dart';
import 'package:astro_life/services/user_services.dart';
import 'package:astro_life/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:hugeicons/hugeicons.dart';
import 'package:astro_life/screens/auth/login_screen.dart';
import 'dart:async';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();

  DateTime? _selectedBirthDate;
  TimeOfDay? _selectedBirthTime;
  String _selectedGender = 'Male';
  bool _isLoading = false;

  // State for password visibility
  bool _isPasswordVisible = false;

  final UserService _userService = UserService();

  // --- Utility & Validation Methods ---

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please set a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a contact number.';
    }
    // Basic number check. Could be enhanced with specific country formats.
    if (!RegExp(r'^[0-9+() -]+$').hasMatch(value)) {
      return 'Invalid characters in contact number.';
    }
    return null;
  }

  Future<void> _register() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Check form validation and date/time pickers
    if (!_formKey.currentState!.validate() ||
        _selectedBirthDate == null ||
        _selectedBirthTime == null) {
      CustomSnackBar.show(
        context,
        message:
            "Please fill all required fields, including Date and Time of Birth.",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final birthDateStr = _selectedBirthDate!.toIso8601String().split('T')[0];
      final birthTimeStr = _selectedBirthTime!.format(context);

      final newUser = User(
        // The original code uses a User model. Assuming it's correct.
        firstName: _firstNameController.text.trim(),
        middleName:
            _middleNameController.text.trim().isEmpty
                ? null
                : _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password:
            _passwordController
                .text, // In a real app, hash this before sending!
        contact: _contactController.text.trim(),
        address: _addressController.text.trim(),
        birthDate: birthDateStr,
        birthTime: birthTimeStr,
        gender: _selectedGender,
        profilePictureUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Simulate a successful API call or replace with actual service logic
      await _userService.createUser(newUser);

      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: "Registration successful! Please log in.",
      );

      // Navigate to Login screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      String errorMessage = "Registration failed. Please try again.";
      if (e is Exception && e.toString().contains('Email already in use')) {
        errorMessage = "The email address is already registered.";
      }

      CustomSnackBar.show(context, message: errorMessage, isError: true);
      debugPrint('Registration failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        // Format date string for the controller: YYYY-MM-DD
        _birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // ... (rest of the _RegisterScreenState class)

  Future<void> _selectBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedBirthTime ?? TimeOfDay.now(),

      // FIX: Apply the MediaQuery override directly to the TimePicker's internal structure.
      builder: (BuildContext context, Widget? child) {
        // Ensure the TimePicker is wrapped in a MediaQuery that forces
        // the text scale factor back to 1.0 (normal size).
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child:
              child!, // Apply the constrained MediaQuery to the actual TimePicker widget (child).
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthTime = picked;
        // The TimeOfDay format uses the context's locale settings (12h or 24h).
        _birthTimeController.text = picked.format(context);
      });
    }
  }

  // ... (rest of the _RegisterScreenState class)
  // --- Widget Builders ---

  // Refined Input Decoration: Cleaned up prefixIcon handling and removed the redundant SizedBox for centering.
  InputDecoration _inputDecoration(
    String label,
    Widget prefixIcon, {
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      isDense: true,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
        child: prefixIcon,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ), // Consolidate icon constraints
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required HugeIcon icon,
    bool obscure = false,
    String? Function(String?)? validator,
    void Function()? onTap,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // Scale the icon down slightly for a cleaner look without using Transform.scale
    final scaledIcon = HugeIcon(
      icon: icon.icon,
      color: colorScheme.primary,
      size: 20.0, // Adjusted size
    );

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
      ), // Increased font size for legibility
      keyboardType: keyboardType,
      inputFormatters: formatters,
      decoration: _inputDecoration(label, scaledIcon, suffixIcon: suffixIcon),
      validator: validator,
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 650;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 64 : 32,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 650 : double.infinity,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Text
                  Text(
                    "Sign Up",
                    style: textTheme.displaySmall?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Create your account for personalized insights",
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Main Form Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    color: colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Name Fields (Responsive Row/Column)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                bool isNarrow = constraints.maxWidth < 450;
                                List<Widget> nameFields = [
                                  _buildTextField(
                                    controller: _firstNameController,
                                    label: "First Name",
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedUser03,
                                    ),
                                    validator:
                                        (v) =>
                                            _validateRequired(v, "first name"),
                                  ),
                                  if (!isNarrow) const SizedBox(width: 16),
                                  if (isNarrow) const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _middleNameController,
                                    label: "Middle Name",
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedUser03,
                                    ),
                                  ),
                                  if (!isNarrow) const SizedBox(width: 16),
                                  if (isNarrow) const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _lastNameController,
                                    label: "Last Name",
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedUser03,
                                    ),
                                    validator:
                                        (v) =>
                                            _validateRequired(v, "last name"),
                                  ),
                                ];

                                return isNarrow
                                    ? Column(children: nameFields)
                                    : Row(
                                      children:
                                          nameFields
                                              .map((w) => Expanded(child: w))
                                              .toList(),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),

                            // 2. Email
                            _buildTextField(
                              controller: _emailController,
                              label: "Email Address",
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedMail01,
                              ),
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24),

                            // 3. Password
                            _buildTextField(
                              controller: _passwordController,
                              label: "Password",
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedLockPassword,
                              ),
                              obscure: !_isPasswordVisible,
                              validator: _validatePassword,
                              suffixIcon: IconButton(
                                icon: HugeIcon(
                                  icon:
                                      _isPasswordVisible
                                          ? HugeIcons.strokeRoundedView
                                          : HugeIcons.strokeRoundedViewOff,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 4. Contact Number
                            _buildTextField(
                              controller: _contactController,
                              label: "Contact Number",
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedContact,
                              ),
                              validator: _validateContact,
                              keyboardType: TextInputType.phone,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 24),

                            // 5. Birth Date & Time (Side-by-side or stacked)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                bool isNarrow = constraints.maxWidth < 350;
                                List<Widget> dateTimeFields = [
                                  _buildTextField(
                                    controller: _birthDateController,
                                    label: "Date of Birth",
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedCalendar01,
                                    ),
                                    validator:
                                        (_) =>
                                            _selectedBirthDate == null
                                                ? "Select date"
                                                : null,
                                    readOnly: true,
                                    onTap: _selectBirthDate,
                                  ),
                                  if (!isNarrow) const SizedBox(width: 16),
                                  if (isNarrow) const SizedBox(height: 16),
                                  _buildTextField(
                                    controller: _birthTimeController,
                                    label: "Birth Time",
                                    icon: HugeIcon(
                                      icon: HugeIcons.strokeRoundedClock04,
                                    ),
                                    validator:
                                        (_) =>
                                            _selectedBirthTime == null
                                                ? "Select time"
                                                : null,
                                    readOnly: true,
                                    onTap: _selectBirthTime,
                                  ),
                                ];

                                return isNarrow
                                    ? Column(children: dateTimeFields)
                                    : Row(
                                      children:
                                          dateTimeFields
                                              .map((w) => Expanded(child: w))
                                              .toList(),
                                    );
                              },
                            ),
                            const SizedBox(height: 24),

                            // 6. Address
                            _buildTextField(
                              controller: _addressController,
                              label: "Place of Birth / Address",
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedHome03,
                              ),
                              validator:
                                  (v) => _validateRequired(v, "place/address"),
                            ),
                            const SizedBox(height: 24),

                            // 7. Gender Selection (Refined UI)
                            _buildGenderSegmentedButton(
                              colorScheme,
                              textTheme,
                              _selectedGender,
                              (s) => setState(() => _selectedGender = s.first),
                            ),

                            const SizedBox(height: 32),

                            // 8. Submit Button
                            _isLoading
                                ? Center(
                                  child: CircularProgressIndicator(
                                    color: colorScheme.primary,
                                  ),
                                )
                                : SizedBox(
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: _register,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: Text(
                                      "Create Account",
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Already have an account? Login",
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
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

  // Extracted Gender Segmented Button for clean build method
  Widget _buildGenderSegmentedButton(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String selectedGender, // Pass selected state in
    Function(Set<String>) onSelectionChanged, // Pass handler in
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'Gender', // Added asterisk for consistency
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // --- Refinement: Wrap in SizedBox for explicit full width ---
        SizedBox(
          width:
              double
                  .infinity, // Forces the SegmentedButton to take full available width
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'Male',
                label: const Text('Male'),
                icon: HugeIcon(icon: HugeIcons.strokeRoundedMan, size: 20),
              ),
              ButtonSegment(
                value: 'Female',
                label: const Text('Female'),
                icon: HugeIcon(icon: HugeIcons.strokeRoundedWoman, size: 20),
              ),
              ButtonSegment(value: 'Other', label: const Text('Other')),
            ],
            // Use the passed-in state and handler
            selected: {selectedGender},
            onSelectionChanged: onSelectionChanged,

            style: SegmentedButton.styleFrom(
              // The style looks great, ensuring full width utilization
              selectedBackgroundColor: colorScheme.primary.withOpacity(0.15),
              selectedForegroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
            showSelectedIcon: true, // Re-enabled selected icon for better UX
          ),
        ),
      ],
    );
  }
}
