import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/personality_assessment_screen.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/game_provider.dart';
import 'providers/progress_provider.dart';
import 'utils/constants.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'screens/conversation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
  } catch (e) {
    exit(1); // Exit if .env file cannot be loaded
  }
  // Access your API key from the environment variables
  final apiKey = dotenv.env['GEMINI_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    exit(1); // Exit if API_KEY is not found
  }
  // Initialize the GenerativeModel
  GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  runApp(const LifeTalkApp());
}

class LifeTalkApp extends StatelessWidget {
  const LifeTalkApp({super.key});

  Future<bool> _shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('onboarding_seen') ?? false);
  }

  Future<bool> _shouldShowPersonalityAssessment() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('personality_assessment_completed') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'LifeTalk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: FutureBuilder<bool>(
          future: _shouldShowOnboarding(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            if (snapshot.data == true) {
              return const OnboardingScreen();
            } else {
              return FutureBuilder<bool>(
                future: _shouldShowPersonalityAssessment(),
                builder: (context, personalitySnapshot) {
                  if (!personalitySnapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  if (personalitySnapshot.data == true) {
                    return const PersonalityAssessmentScreen();
                  } else {
                    return Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        if (authProvider.isAuthenticated) {
                          return const HomeScreen();
                        } else {
                          return const LoginScreen();
                        }
                      },
                    );
                  }
                },
              );
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/personality-assessment': (context) =>
              const PersonalityAssessmentScreen(),
          '/home': (context) => const HomeScreen(),
          '/conversation': (context) => const ResumeConversationScreen(),
        },
      ),
    );
  }
}

class ResumeConversationScreen extends StatelessWidget {
  const ResumeConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final scenario = gameProvider.currentScenario;
    if (scenario == null) {
      // If no scenario, fallback to home
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
      return const SizedBox.shrink();
    }
    return ConversationScreen(scenario: scenario);
  }
}
