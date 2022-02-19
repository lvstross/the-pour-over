import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

// @TODO: added a loading state for fetching the articles.
class ArchiveItem {
  final String title;
  final String date;
  final String path;

  ArchiveItem({required this.title, required this.date, required this.path});
}

class ArchiveList extends StatefulWidget {
  const ArchiveList({Key? key}) : super(key: key);

  @override
  State<ArchiveList> createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  List<ArchiveItem> archiveItems = [];

  @override
  void initState() {
    getEmailCampArchive();
    super.initState();
  }

  void getEmailCampArchive() async {
    Uri archiveUri = Uri(
        scheme: 'https',
        host: 'us18.campaign-archive.com',
        path: '/home',
        queryParameters: {
          'u': 'ea0a75014fe3a75c627fb5842',
          'id': '67e3d09860'
        });
    final response = await http.get(archiveUri);

    String responseBody = response.body;
    var document = parse(responseBody);
    var archiveList = document.getElementsByClassName('campaign');
    List<ArchiveItem> items = [];

    for (var element in archiveList) {
      var inner = element.innerHtml.toString();
      var title = element.text;
      if (inner.contains('href')) {
        RegExp exp = RegExp(r'(["])(?:(?=(\\?))\2.)*?\1');
        Iterable<RegExpMatch> matches = exp.allMatches(inner);
        List<String?> attrs = [];
        for (var m in matches) {
          var groupItem = m.group(0);
          attrs.add(groupItem?.substring(1, groupItem.length - 1));
        }
        items.add(ArchiveItem(
            title: title, date: inner.split('-')[0], path: attrs[0] as String));
      }
    }

    setState(() {
      archiveItems = items;
    });
  }

  void _openArticleUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Pour Over'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: ListView(
              padding: const EdgeInsets.all(8),
              children: archiveItems.map((ArchiveItem item) {
                return GestureDetector(
                  onTap: () => {_openArticleUrl(item.path)},
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(
                              // color: const Color.fromARGB(255, 176, 176, 176),
                              color: Theme.of(context).colorScheme.primary,
                              width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Color.fromRGBO(241, 129, 125, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}
