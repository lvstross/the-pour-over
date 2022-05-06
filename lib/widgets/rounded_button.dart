import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPress;
  final double size;
  final Widget child;

  const RoundedButton({
    Key? key,
    required this.onPress,
    required this.size,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = const BorderRadius.all(Radius.circular(50));
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onPress,
        child: SizedBox(
          width: size,
          height: size,
          child: child,
        ),
      ),
    );
  }
}
