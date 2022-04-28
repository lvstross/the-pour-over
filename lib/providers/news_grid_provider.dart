import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

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

  NewsGridProvider() {
    updateLoading(true);
    getNewsGrid();
  }

  List<NewsItem> get newsItems => _newsItems;
  bool get isLoading => _isLoading;

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
    // loop through titls as the consistent length range
    titles.asMap().forEach((index, value) {
      newsGrid.add(HtmlNewsElement(
          title: value, date: dates[index], author: authors[index]));
    });
    return newsGrid;
  }

  void getNewsGrid() async {
    Uri newsUri = Uri(
      scheme: 'https',
      host: 'www.thepourover.org',
      path: '/news',
    );
    final response = await http.get(newsUri);

    String responseBody = response.body;
    var document = parse(responseBody);
    // newsAuthors and newsDates will be doubled up because of duplicate meta tags for each article tag
    // will need to purge every other one to line up with the newsTitles
    var authors = getEveryOtherItem(
        document.getElementsByClassName('blog-author')); // span with innerText
    var dates = getEveryOtherItem(
        document.getElementsByClassName('blog-date')); // time with innerText
    var newsTitles =
        document.getElementsByClassName('blog-title'); // a tag inside with href

    List<HtmlNewsElement> newsGrid =
        zipNewsGridData(authors, dates, newsTitles);
    List<NewsItem> items = [];

    for (var element in newsGrid) {
      String author = element.author.innerHtml.toString();
      String date = element.date.innerHtml.toString();
      String title = element.title.text.trim();
      String inner = element.title.innerHtml.toString();
      if (inner.contains('href')) {
        RegExp exp = RegExp(r'(["])(?:(?=(\\?))\2.)*?\1');
        Iterable<RegExpMatch> matches = exp.allMatches(inner);
        List<String?> attrs = [];
        for (var m in matches) {
          var groupItem = m.group(0);
          attrs.add(groupItem?.substring(1, groupItem.length - 1));
        }
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
    updateLoading(false);
  }

  void saveItems(List<NewsItem> items) {
    _newsItems = items;
    notifyListeners();
  }

  void updateLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
