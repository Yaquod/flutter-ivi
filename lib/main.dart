import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ivi/screens/main_screen.dart';
import 'package:flutter_ivi/features/spotify/providers/spotify_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env not bundled or not found — Spotify features will be disabled
    debugPrint('[main] dotenv not loaded: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SpotifyProvider>(
          create: (_) => SpotifyProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IVI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}
