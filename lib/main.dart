import 'package:flutter/material.dart';
import 'package:pour_over_app/screens/ArchiveList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'The Pour Over',
        initialRoute: '/',
        routes: {
          '/': (context) => const ArchiveList(),
        },
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                background: Color.fromRGBO(255, 255, 255, 1),
                primary: Color.fromRGBO(241, 129, 125, 1),
                secondary: Color.fromRGBO(241, 129, 125, 0.5)),
            textTheme: const TextTheme(button: TextStyle(color: Colors.black))),
        darkTheme: ThemeData(
            colorScheme: const ColorScheme.dark(
                background: Color.fromARGB(255, 82, 82, 82),
                primary: Color.fromRGBO(241, 129, 125, 1),
                secondary: Color.fromRGBO(241, 129, 125, 0.5)),
            textTheme: const TextTheme(
                button: TextStyle(
              color: Colors.white,
            ))));
  }
}
