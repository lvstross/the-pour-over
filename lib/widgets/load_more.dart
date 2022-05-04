import 'package:flutter/material.dart';

class LoadMore extends StatelessWidget {
  const LoadMore({
    Key? key,
    required this.onPress,
    required this.isLoading,
  }) : super(key: key);

  final VoidCallback onPress;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary)
            : Material(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Theme.of(context).colorScheme.background,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  onTap: onPress,
                  child: const SizedBox(
                    width: 230,
                    height: 50,
                    child: Center(
                      child: Text('See More'),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
