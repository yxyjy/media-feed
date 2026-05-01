import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/feed_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized() is required if you do anything
  // async before runApp (e.g., reading SharedPreferences, Firebase init).
  // Not strictly needed here, but it's a good habit.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is the Riverpod equivalent of a context root.
    // ALL providers live inside this scope. It MUST be an ancestor of every
    // widget that uses ref.watch or ref.read. Wrap it around your whole app.
    const ProviderScope(child: MediaFeedApp()),
  );
}

class MediaFeedApp extends StatelessWidget {
  const MediaFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Feed App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const FeedScreen(),
    );
  }
}
