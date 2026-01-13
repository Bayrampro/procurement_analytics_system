import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/init/data_initializer.dart';
import 'presentation/screens/root_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация сервисов
  ServiceLocator().init();
  // Инициализация данных из CSV при первом запуске
  await DataInitializer().seedIfEmpty();

  // Устанавливаем ориентацию только портретная для Windows
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RussoOne',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Индиго
          brightness: Brightness.light,
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
          surface: Colors.white,
          background: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'RussoOne'),
          displayMedium: TextStyle(fontFamily: 'RussoOne'),
          displaySmall: TextStyle(fontFamily: 'RussoOne'),
          headlineLarge: TextStyle(fontFamily: 'RussoOne'),
          headlineMedium: TextStyle(fontFamily: 'RussoOne'),
          headlineSmall: TextStyle(fontFamily: 'RussoOne'),
          titleLarge: TextStyle(fontFamily: 'RussoOne'),
          titleMedium: TextStyle(fontFamily: 'RussoOne'),
          titleSmall: TextStyle(fontFamily: 'RussoOne'),
          bodyLarge: TextStyle(fontFamily: 'RussoOne'),
          bodyMedium: TextStyle(fontFamily: 'RussoOne'),
          bodySmall: TextStyle(fontFamily: 'RussoOne'),
          labelLarge: TextStyle(fontFamily: 'RussoOne'),
          labelMedium: TextStyle(fontFamily: 'RussoOne'),
          labelSmall: TextStyle(fontFamily: 'RussoOne'),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E293B),
          titleTextStyle: const TextStyle(
            fontFamily: 'RussoOne',
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
          toolbarTextStyle: const TextStyle(
            fontFamily: 'RussoOne',
          ),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const RootShell(),
    );
  }
}
