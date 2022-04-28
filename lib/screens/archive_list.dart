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
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                                    style: const TextStyle(fontSize: 16),
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
                    ),
                  );
                }).toList()),
      ),
    );
  }
}
