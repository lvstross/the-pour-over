import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pour_over_app/providers/archive_list_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchiveList extends StatelessWidget {
  const ArchiveList({Key? key}) : super(key: key);

  void _openArticleUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String truncate(String val) {
    if (val.length > 35) {
      return val.substring(0, 35) + '...';
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    List<ArchiveItem> archiveItems =
        context.watch<ArchiveListProvider>().archiveItems;
    bool isLoading = context.watch<ArchiveListProvider>().isLoading;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary),
              )
            : ListView(
                padding: const EdgeInsets.all(8),
                children: archiveItems.map((ArchiveItem item) {
                  return GestureDetector(
                    onTap: () => {_openArticleUrl(item.path)},
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.date,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  truncate(item.title),
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Color.fromRGBO(241, 129, 125, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()),
      ),
    );
  }
}
