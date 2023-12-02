import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Injecting dependency injection
  runApp(const MyApp());
}

// Business Logic -> Use Cases
// Business Object -> Entities
// Domain layer should be totally independent of every other layer.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade800,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
