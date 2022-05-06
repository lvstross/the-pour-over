import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webfeed/webfeed.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pour_over_app/widgets/podcast_list_item.dart';
import 'package:pour_over_app/providers/podcast_feed_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    Function updateShowAudioPlayer =
        context.watch<PodcastFeedProvider>().updateShowAudioPlayer;
    Function updatePlayingUrl =
        context.watch<PodcastFeedProvider>().updatePlayingUrl;

    void setPodcastAudio(String url) {
      // @todo: Audio does not update while audio is playing
      // Make it so that the audio url changes and the player resets back.
      updatePlayingUrl(url);
      updateShowAudioPlayer(true);
    }

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : AnimationLimiter(
              child: ListView.builder(
                itemCount: _podcastItems.length,
                itemBuilder: (BuildContext context, int index) {
                  String title = _podcastItems[index].title as String;
                  Html description = Html(
                    data: _podcastItems[index].description,
                    onLinkTap: (String? url, RenderContext context,
                        Map<String, String> attributes, dom.Element? element) {
                      _openArticleUrl(url);
                    },
                  );

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 275),
                    child: index % 2 == 0
                        ? SlideAnimation(
                            horizontalOffset: -500.0,
                            delay: const Duration(milliseconds: 200),
                            child: PodcastListItem(
                              title: title,
                              description: description,
                              onPress: () => setPodcastAudio(
                                  _podcastItems[index].enclosure?.url
                                      as String),
                            ),
                          )
                        : SlideAnimation(
                            horizontalOffset: 500.0,
                            delay: const Duration(milliseconds: 200),
                            child: PodcastListItem(
                              title: title,
                              description: description,
                              onPress: () => setPodcastAudio(
                                  _podcastItems[index].enclosure?.url
                                      as String),
                            ),
                          ),
                  );
                },
              ),
            ),
    );
  }
}
