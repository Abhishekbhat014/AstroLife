import 'package:astro_life/screens/auth/register_screen.dart';
import 'package:astro_life/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:astro_life/screens/home/home_screen.dart';
import 'package:astro_life/services/user_services.dart';
import 'package:astro_life/models/user_model.dart';
import 'package:astro_life/screens/auth/forgot_password_screen.dart'; // NEW IMPORT
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final UserService _userService = UserService();

  // Define a standard icon size for consistency
  static const double _iconSize = 20.0;
  static const double _inputRadius = 18.0;
  static const double _cardRadius = 28.0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic (Unchanged) ---

  void _login() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        final User? user = await _userService.getUserByEmail(email);

        await Future.delayed(const Duration(milliseconds: 500));

        if (user == null) {
          throw Exception("User not found.");
        }

        if (user.password != password) {
          throw Exception("Incorrect password.");
        }

        if (mounted) {
          CustomSnackBar.show(
            context,
            message: "Welcome back, ${user.firstName}!",
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = "Login failed. Please check credentials.";
          if (e.toString().contains("Incorrect password")) {
            errorMessage = "Incorrect password.";
          } else if (e.toString().contains("User not found")) {
            errorMessage = "Email not registered.";
          }

          CustomSnackBar.show(context, message: errorMessage, isError: true);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // --- Widget Builders (Unchanged) ---

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
      filled: true,
      fillColor: colorScheme.surface,

      // Embed the prefixIcon directly (already wrapped in Padding/sized in builders)
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 8.0),
        child: prefixIcon, // Use the passed widget
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      suffixIcon: suffixIcon,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 16.0,
      ),

      // Consistent border styling
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputRadius),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
    );
  }

  Widget _buildEmailField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      style: const TextStyle(fontSize: 16.0),
      decoration: _inputDecoration(
        "Email Address",
        HugeIcon(
          icon: HugeIcons.strokeRoundedMail01,
          color: colorScheme.primary,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      style: const TextStyle(fontSize: 16.0),
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration(
        "Password",
        HugeIcon(
          icon: HugeIcons.strokeRoundedLockPassword,
          color: colorScheme.primary,
          size: _iconSize,
        ),
        suffixIcon: IconButton(
          icon: HugeIcon(
            icon:
                _isPasswordVisible
                    ? HugeIcons.strokeRoundedView
                    : HugeIcons.strokeRoundedViewOff,
            color: colorScheme.onSurfaceVariant,
            size: _iconSize,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  // --- Background Helper (Unchanged) ---

  Widget _buildBackgroundDecorator(
    Color color,
    Alignment alignment,
    double size,
  ) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorations
            _buildBackgroundDecorator(
              colorScheme.primary.withOpacity(0.06),
              Alignment.topRight,
              280,
            ),
            _buildBackgroundDecorator(
              colorScheme.secondary.withOpacity(0.06),
              Alignment.bottomLeft,
              230,
            ),

            LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 64 : 32,
                      vertical: 48,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 500 : double.infinity,
                      ),
                      child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_cardRadius),
                          side: BorderSide(
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header Title
                                Text(
                                  "Welcome Back",
                                  style: textTheme.headlineLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Sign in to your account",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onBackground.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 48),

                                // Form Fields
                                _buildEmailField(colorScheme),
                                const SizedBox(height: 20),
                                _buildPasswordField(colorScheme),
                                const SizedBox(height: 32),

                                // Login Button
                                _isLoading
                                    ? Center(
                                      child: CircularProgressIndicator(
                                        color: colorScheme.primary,
                                      ),
                                    )
                                    : SizedBox(
                                      height: 58,
                                      child: FilledButton(
                                        onPressed: _login,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              _inputRadius,
                                            ),
                                          ),
                                          elevation: 6,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: textTheme.titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 16),

                                // Forgot Password link - UPDATED NAVIGATION
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Sign Up Link (Footer)
                                Divider(
                                  color: colorScheme.onSurface.withOpacity(0.1),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Create a new account",
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
