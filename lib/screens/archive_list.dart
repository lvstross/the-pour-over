import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pour_over_app/providers/archive_list_provider.dart';
import 'package:pour_over_app/widgets/archive_list_item.dart';

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
            : AnimationLimiter(
                child: ListView.builder(
                  itemCount: archiveItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 275),
                      child: SlideAnimation(
                        verticalOffset: 500.0,
                        horizontalOffset: 500.0,
                        child: ArchiveListItem(
                          onPress: () =>
                              {_openArticleUrl(archiveItems[index].path)},
                          itemIndex: index,
                          date: archiveItems[index].date,
                          title: truncate(archiveItems[index].title),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
