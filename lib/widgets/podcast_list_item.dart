import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PodcastListItem extends StatelessWidget {
  const PodcastListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final Html description;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
          description,
          // Audio tags don't render correctly: https://github.com/Sub6Resources/flutter_html/issues/989
          // Html(
          //   data:
          //       '<audio controls="true" autoplay="false" src="${_podcastItems[index].enclosure?.url}"></audio>',
          // )
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                onTap: onPress,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.play_arrow,
                    size: 35,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
