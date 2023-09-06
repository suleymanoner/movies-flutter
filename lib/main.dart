import 'package:flutter/material.dart';
import 'package:movies/screens/authentication.dart';
import 'package:movies/screens/splash.dart';
import 'package:movies/themes/app_theme.dart';
import 'package:movies/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: AppTheme().cardTheme,
        elevatedButtonTheme: AppTheme().elevatedButtonTheme,
        textTheme: AppTheme().textTheme,
        snackBarTheme: AppTheme().snackBarTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.primary,
          foregroundColor: kDarkColorScheme.primaryContainer,
        ),
        cardTheme: AppTheme().darkCardTheme,
        elevatedButtonTheme: AppTheme().darkElevatedButtonTheme,
        textTheme: AppTheme().darkTextTheme,
        snackBarTheme: AppTheme().snackBarTheme,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const Splash(),
        '/auth': (context) => const AuthenticationScreen(),
      },
    );
  }
}
