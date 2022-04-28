import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:pour_over_app/providers/utils.dart';

class NewsItem {
  final String author;
  final String title;
  final String date;
  final String path;

  NewsItem({
    required this.author,
    required this.title,
    required this.date,
    required this.path,
  });
}

class HtmlNewsElement {
  final dom.Element title;
  final dom.Element date;
  final dom.Element author;

  HtmlNewsElement({
    required this.title,
    required this.date,
    required this.author,
  });
}

class NewsGridProvider with ChangeNotifier {
  List<NewsItem> _newsItems = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _olderPath = '';

  NewsGridProvider() {
    updateLoading(true);
    getNewsGrid();
  }

  List<NewsItem> get newsItems => _newsItems;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get olderPath => _olderPath;
  Function get getNews => getNewsGrid;

  List<dynamic> getEveryOtherItem(List items) {
    var newItems = [];
    items.asMap().forEach((index, value) {
      if (index % 2 == 0) {
        newItems.add(value);
      }
    });
    return newItems;
  }

  List<HtmlNewsElement> zipNewsGridData(List authors, List dates, List titles) {
    List<HtmlNewsElement> newsGrid = [];
    titles.asMap().forEach((index, value) {
      newsGrid.add(HtmlNewsElement(
          title: value, date: dates[index], author: authors[index]));
    });
    return newsGrid;
  }

  void getNewsGrid() async {
    // Set query params if there that can be loaded from initial load
    Map<String, dynamic> params = {};
    if (_olderPath != '') {
      updateLoadingMore(true);
      List<String> splitParams = _olderPath.split('?')[1].split('=');
      params[splitParams[0]] = splitParams[1];
    }

    // Make request for html
    Uri newsUri = Uri(
      scheme: 'https',
      host: 'www.thepourover.org',
      path: '/news',
      queryParameters: params,
    );
    final response = await http.get(newsUri);
    String responseBody = response.body;

    // Parse document into it's needed parts
    var document = parse(responseBody);
    // newsAuthors and newsDates will be doubled up because of duplicate meta tags for each article tag getEveryOtherItem will purge the duplicates to line up with the newsTitles
    List<dynamic> authors = getEveryOtherItem(document
        .getElementsByClassName('blog-author')); // span tag with innerHtml
    List<dynamic> dates = getEveryOtherItem(document
        .getElementsByClassName('blog-date')); // time tag with innerHtml
    List<dom.Element> newsTitles = document
        .getElementsByClassName('blog-title'); // a tag as child with href
    // Handle older posts link if there is one
    List<dom.Element> olderPosts = document.getElementsByClassName('older');
    if (olderPosts.isNotEmpty) {
      String innerTag = olderPosts[0].innerHtml.toString();
      if (innerTag.contains('href')) {
        List<String?> attrs = getElementAttributeValues(innerTag);
        updateOlderPath(attrs[0] as String);
      }
    }

    // Zip the element items into a list and create usable UI items
    List<HtmlNewsElement> newsGrid =
        zipNewsGridData(authors, dates, newsTitles);
    List<NewsItem> items = [];

    for (var element in newsGrid) {
      String author = element.author.innerHtml.toString();
      String date = element.date.innerHtml.toString();
      String title = element.title.text.trim();
      String inner = element.title.innerHtml.toString();
      if (inner.contains('href')) {
        List<String?> attrs = getElementAttributeValues(inner);
        var pathUrl = 'https://www.thepourover.org${attrs[0]}';
        items.add(NewsItem(
          author: author,
          title: title,
          date: date,
          path: pathUrl,
        ));
      }
    }

    saveItems(items);
    if (_isLoading) updateLoading(false);
    if (_isLoadingMore) updateLoadingMore(false);
  }

  void saveItems(List<NewsItem> items) {
    _newsItems = [..._newsItems, ...items];
    notifyListeners();
  }

  void updateLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateLoadingMore(bool loading) {
    _isLoadingMore = loading;
    notifyListeners();
  }

  void updateOlderPath(String path) {
    _olderPath = path;
    notifyListeners();
  }
}
