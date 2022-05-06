import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class PodcastFeedProvider with ChangeNotifier {
  List<RssItem>? _podcastItems = [];
  bool _isLoading = false;
  String _currPlayUrl = '';
  bool _showAudioPlayer = false;

  PodcastFeedProvider() {
    updateLoading(true);
    getRssFeed();
  }

  List<RssItem> get podcastItems => _podcastItems ?? [];
  bool get isLoading => _isLoading;
  String get currentPlayingUrl => _currPlayUrl;
  bool get showAudioPlayer => _showAudioPlayer;

  void getRssFeed() async {
    Uri feedUri = Uri(
      scheme: 'https',
      host: 'feeds.buzzsprout.com',
      path: '/1835468.rss',
    );
    final response = await http.get(feedUri);

    String responseBody = response.body;
    var rssFeed = RssFeed.parse(responseBody);
    saveItems(rssFeed.items);
    updateLoading(false);
  }

  void saveItems(List<RssItem>? items) {
    _podcastItems = items;
    notifyListeners();
  }

  void updateLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateShowAudioPlayer(bool show) {
    _showAudioPlayer = show;
    notifyListeners();
  }

  void updatePlayingUrl(String url) {
    _currPlayUrl = url;
    notifyListeners();
  }
}
