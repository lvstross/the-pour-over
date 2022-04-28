import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pour_over_app/providers/news_grid_provider.dart';

class NewsGrid extends StatelessWidget {
  const NewsGrid({Key? key}) : super(key: key);

  void _openArticleUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<NewsItem> _newsItems = context.watch<NewsGridProvider>().newsItems;
    bool _isLoading = context.watch<NewsGridProvider>().isLoading;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : GridView.builder(
              itemCount: _newsItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {_openArticleUrl(_newsItems[index].path)},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                              child: Text(
                                _newsItems[index].date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                _newsItems[index].author,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Text(
                              _newsItems[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}