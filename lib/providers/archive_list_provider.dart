import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class ArchiveItem {
  final String title;
  final String date;
  final String path;

  ArchiveItem({required this.title, required this.date, required this.path});
}

class ArchiveListProvider with ChangeNotifier {
  List<ArchiveItem> _archiveItems = [];
  bool _isLoading = false;

  ArchiveListProvider() {
    updateLoading(true);
    getEmailCampArchive();
  }

  List<ArchiveItem> get archiveItems => _archiveItems;
  bool get isLoading => _isLoading;

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
      String inner = element.innerHtml.toString();
      String title = element.text.split(' - ')[1];
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

    saveItems(items);
    updateLoading(false);
  }

  void saveItems(List<ArchiveItem> items) {
    _archiveItems = items;
    notifyListeners();
  }

  void updateLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
