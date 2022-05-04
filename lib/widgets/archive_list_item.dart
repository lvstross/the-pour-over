import 'package:flutter/material.dart';

class ArchiveListItem extends StatelessWidget {
  const ArchiveListItem({
    Key? key,
    required this.onPress,
    required this.itemIndex,
    required this.date,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPress;
  final int itemIndex;
  final String date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: itemIndex == 0
            ? const EdgeInsets.only(top: 8, bottom: 4, left: 8, right: 8)
            : const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Color.fromRGBO(241, 129, 125, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
