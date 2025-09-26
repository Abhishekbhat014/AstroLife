import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:astro_life/widgets/custom_snackbar.dart';
import 'package:astro_life/screens/auth/reset_password_screen.dart';
import 'package:flutter/services.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String correctOtp;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.correctOtp,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  final int _otpLength = 6;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != _otpLength) {
      CustomSnackBar.show(
        context,
        message: "Please enter the 6-digit code.",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate verification time

      if (_otpController.text == widget.correctOtp) {
        // Success: Navigate to the reset password screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(email: widget.email),
            ),
          );
        }
      } else {
        throw Exception("Invalid verification code.");
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: "Verification failed. Invalid code.",
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Code"),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Verification",
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter the 6-digit code sent to ${widget.email}",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // OTP Input Field (Stylized for 6 digits)
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: _otpLength,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: textTheme.headlineMedium?.copyWith(
                      letterSpacing:
                          0.32,
                      fontSize: 24,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Code',
                      counterText: "", 
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
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
                          onPressed: _verifyOtp,
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            "Verify Code",
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
    );
  }
}
