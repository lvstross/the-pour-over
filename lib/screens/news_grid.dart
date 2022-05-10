import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pour_over_app/widgets/load_more.dart';
import 'package:pour_over_app/widgets/news_grid_item.dart';
import 'package:pour_over_app/providers/news_grid_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    bool _isLoadingMore = context.watch<NewsGridProvider>().isLoadingMore;
    Function _fetchMoreNews = context.watch<NewsGridProvider>().getNews;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AnimationLimiter(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _newsItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 275),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: NewsGridItem(
                                  onPress: () =>
                                      {_openArticleUrl(_newsItems[index].path)},
                                  date: _newsItems[index].date,
                                  author: _newsItems[index].author,
                                  title: _newsItems[index].title,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  LoadMore(
                    onPress: () => _fetchMoreNews(),
                    isLoading: _isLoadingMore,
                  )
                ],
              ),
            ),
    );
  }
}
