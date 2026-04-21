import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../ui/components/app_logo.dart';
import '../ui/components/fintech_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onSwitchToRegister,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final VoidCallback onLoginSuccess;
  final VoidCallback onSwitchToRegister;
  final ThemeMode themeMode;
  final Future<void> Function() onToggleTheme;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ApiService.login(
        _usernameController.text,
        _passwordController.text,
      );
      widget.onLoginSuccess();
    } catch (error) {
      setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      themeMode: widget.themeMode,
      onToggleTheme: widget.onToggleTheme,
      title: 'Welcome back',
      subtitle: 'Sign in to access your secure finance dashboard.',
      footerText: 'Need an account?',
      footerAction: 'Register',
      onFooterPressed: widget.onSwitchToRegister,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: Text(_isLoading ? 'Signing in...' : 'Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({
    required this.themeMode,
    required this.onToggleTheme,
    required this.title,
    required this.subtitle,
    required this.footerText,
    required this.footerAction,
    required this.onFooterPressed,
    required this.child,
  });

  final ThemeMode themeMode;
  final Future<void> Function() onToggleTheme;
  final String title;
  final String subtitle;
  final String footerText;
  final String footerAction;
  final VoidCallback onFooterPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = FintechPalette.primaryTextFor(context);
    final mutedText = FintechPalette.secondaryTextFor(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: FintechPalette.authGradientFor(context),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? const Color(0x22000000) : const Color(0x14072A1F),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
                border: Border.all(color: FintechPalette.strokeFor(context)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StudentFinanceLogo(
                        size: 56,
                        title: 'Student Finance',
                        subtitle: 'Personal expense tracker',
                        foregroundColor: textColor,
                      ),
                      IconButton(
                        onPressed: onToggleTheme,
                        icon: Icon(
                          themeMode == ThemeMode.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(color: mutedText, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  child,
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(footerText, style: TextStyle(color: mutedText)),
                      TextButton(
                        onPressed: onFooterPressed,
                        child: Text(footerAction),
                      ),
                    ],
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
