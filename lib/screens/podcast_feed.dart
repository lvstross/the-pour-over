import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:pour_over_app/providers/podcast_feed_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:pour_over_app/widgets/podcast_list_item.dart';

class PodcastFeed extends StatefulWidget {
  const PodcastFeed({Key? key}) : super(key: key);

  @override
  _PodcastFeedState createState() => _PodcastFeedState();
}

class _PodcastFeedState extends State<PodcastFeed> {
  void _openArticleUrl(String? url) async {
    if (await canLaunch(url as String)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RssItem>? _podcastItems =
        context.watch<PodcastFeedProvider>().podcastItems;
    bool _isLoading = context.watch<PodcastFeedProvider>().isLoading;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _podcastItems.length,
              itemBuilder: (context, index) {
                return PodcastListItem(
                    title: _podcastItems[index].title as String,
                    description: Html(
                      data: _podcastItems[index].description,
                      onLinkTap: (String? url,
                          RenderContext context,
                          Map<String, String> attributes,
                          dom.Element? element) {
                        _openArticleUrl(url);
                      },
                    ),
                    onPress: () =>
                        {print(_podcastItems[index].enclosure?.url)});
              },
            ),
    );
  }
}
