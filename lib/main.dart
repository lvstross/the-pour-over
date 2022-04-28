import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pour_over_app/providers/news_grid_provider.dart';
import 'package:pour_over_app/providers/archive_list_provider.dart';
import 'package:pour_over_app/screens/archive_list.dart';
import 'package:pour_over_app/screens/news_grid.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ArchiveListProvider()),
      ChangeNotifierProvider(create: (_) => NewsGridProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Pour Over',
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
          ))),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int pageIndex = 0;

  final pages = [
    const ArchiveList(),
    const NewsGrid(),
  ];

  String getAppBarTitle() {
    switch (pageIndex) {
      case 0:
        return 'Archive List';
      case 1:
        return 'News Rooms';
      default:
        return 'the pour over';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          getAppBarTitle(),
          style: const TextStyle(fontSize: 26),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: SvgPicture.asset('assets/invert-logo.svg'),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.library_books,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.library_books_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.grid_view_sharp,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.grid_view_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
