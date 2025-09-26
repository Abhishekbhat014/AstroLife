import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:astro_life/widgets/custom_snackbar.dart';
import 'package:astro_life/services/user_services.dart';
import 'package:astro_life/screens/auth/otp_verification_screen.dart';
import 'dart:async';
import 'dart:math';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final UserService _userService = UserService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();

    try {
      // 1. Check if user exists in the local DB
      final user = await _userService.getUserByEmail(email);

      if (user == null) {
        throw Exception("Email not registered.");
      }

      // 2. Simulate OTP generation and sending (In production, replace with real email service)
      final otp = Random().nextInt(900000) + 100000; // Generate 6-digit OTP
      await Future.delayed(const Duration(seconds: 2));

      // 3. Inform the user and navigate to OTP screen
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: "OTP generated for testing: $otp",
          duration: const Duration(seconds: 5),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => OTPVerificationScreen(
                  email: email,
                  correctOtp: otp.toString(),
                ),
          ),
        );
      }
    } catch (e) {
      String errorMessage = "Error: Could not process request.";
      if (e.toString().contains("Email not registered")) {
        errorMessage = "This email is not registered.";
      }
      CustomSnackBar.show(context, message: errorMessage, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Consistent Icon Decoration Helper
    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedMail01,
            color: colorScheme.primary,
            size: 18.0,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
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
      backgroundColor: colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Reset Password",
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your registered email address to receive a verification code.",
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      decoration: inputDecoration("Email Address"),
                    ),

                    const SizedBox(height: 32),

                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        )
                        : SizedBox(
                          height: 56,
                          child: FilledButton(
                            onPressed: _requestOtp,
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Send Verification Code",
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
