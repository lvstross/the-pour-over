// Home Screen
// Displays a column as follows:
// 1. The pour over logo
// 2. The most recent podcast
// 3. Podcast episode sponsore info
// 3. This weeks archive list items
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/thepourover-podcast-logo.jpg',
              width: 250,
              height: 250,
            ),
          ),
        ),
      ],
    );
  }
}
