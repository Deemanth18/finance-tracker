import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'layout/main_layout.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/api_service.dart';
import 'ui/components/fintech_components.dart';
import 'ui/screens/splash_screen.dart';

void main() {
  runApp(const SmartFinanceTrackerApp());
}

class SmartFinanceTrackerApp extends StatefulWidget {
  const SmartFinanceTrackerApp({super.key});

  @override
  State<SmartFinanceTrackerApp> createState() => _SmartFinanceTrackerAppState();
}

class _SmartFinanceTrackerAppState extends State<SmartFinanceTrackerApp> {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);
    if (!mounted) return;
    setState(() {
      _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final nextMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      nextMode == ThemeMode.dark ? 'dark' : 'light',
    );
    if (!mounted) return;
    setState(() => _themeMode = nextMode);
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: FintechPalette.mint,
            brightness: Brightness.light,
          ).copyWith(
            primary: FintechPalette.mint,
            secondary: const Color(0xFF16A34A),
            surface: const Color(0xFFFCFFFD),
            onSurface: const Color(0xFF0D2B1F),
            onPrimary: Colors.white,
          ),
      scaffoldBackgroundColor: const Color(0xFFF5FFF8),
      cardColor: Colors.white,
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFF7FFF9),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF0D2B1F),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: const TextStyle(
          color: Color(0xFF335C49),
          fontSize: 14,
          height: 1.5,
        ),
      ),
      fontFamily: 'Segoe UI',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.85),
        elevation: 0,
        shadowColor: const Color(0x1A000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0x330F5C45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Color(0x330F5C45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: FintechPalette.mint, width: 1.4),
        ),
        labelStyle: const TextStyle(color: Color(0xFF335C49)),
        prefixIconColor: const Color(0xFF335C49),
        hintStyle: const TextStyle(color: Color(0xFF567867)),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(color: Color(0xFF0D2B1F)),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFFFCFFFD)),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FintechPalette.mint,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF16A34A),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );

    final darkTheme = lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: lightTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: const Color(0xFF0F4636),
        onSurface: FintechPalette.textPrimary,
      ),
      scaffoldBackgroundColor: FintechPalette.deepGreen,
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF123F31),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          color: FintechPalette.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: const TextStyle(
          color: FintechPalette.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF0F4636),
        elevation: 0,
        shadowColor: const Color(0x44000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: Colors.white.withOpacity(0.10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.16)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: FintechPalette.mint, width: 1.4),
        ),
        labelStyle: const TextStyle(color: FintechPalette.textSecondary),
        prefixIconColor: FintechPalette.textSecondary,
        hintStyle: const TextStyle(color: FintechPalette.textMuted),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(color: FintechPalette.textPrimary),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFF103D2E)),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FintechPalette.mintSoft,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Finance Tracker',
      theme: lightTheme.copyWith(
        textTheme: lightTheme.textTheme.apply(
          bodyColor: const Color(0xFF0D2B1F),
          displayColor: const Color(0xFF0D2B1F),
        ),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: darkTheme.textTheme.apply(
          bodyColor: FintechPalette.textPrimary,
          displayColor: FintechPalette.textPrimary,
        ),
      ),
      themeMode: _themeMode,
      home: AppBootstrapper(themeMode: _themeMode, onToggleTheme: _toggleTheme),
    );
  }
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final Future<void> Function() onToggleTheme;

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  late final Future<void> _sessionFuture;
  bool showRegister = false;

  @override
  void initState() {
    super.initState();
    _sessionFuture = Future.wait([
      ApiService.initializeSession(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]).then((_) {});
  }

  void _handleAuthenticated() {
    setState(() {});
  }

  Future<void> _handleLogout() async {
    await ApiService.logout();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashScreen();
        }

        if (ApiService.isAuthenticated) {
          return MainLayout(
            username: ApiService.currentUsername ?? 'Finance Admin',
            onLogout: _handleLogout,
            themeMode: widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
          );
        }

        if (showRegister) {
          return RegisterScreen(
            themeMode: widget.themeMode,
            onToggleTheme: widget.onToggleTheme,
            onRegisterSuccess: _handleAuthenticated,
            onSwitchToLogin: () => setState(() => showRegister = false),
          );
        }

        return LoginScreen(
          themeMode: widget.themeMode,
          onToggleTheme: widget.onToggleTheme,
          onLoginSuccess: _handleAuthenticated,
          onSwitchToRegister: () => setState(() => showRegister = true),
        );
      },
    );
  }
}
