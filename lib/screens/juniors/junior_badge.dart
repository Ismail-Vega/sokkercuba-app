import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class JuniorBadge extends StatefulWidget {
  final int weeksLeft;
  final bool isNew;
  final bool showAnimation;

  const JuniorBadge({
    super.key,
    required this.weeksLeft,
    required this.isNew,
    required this.showAnimation,
  });

  @override
  State<JuniorBadge> createState() => _JuniorBadgeState();
}

class _JuniorBadgeState extends State<JuniorBadge> {
  bool _isAnimationCompleted = false;
  String text = '';

  @override
  Widget build(BuildContext context) {
    if (!widget.showAnimation) {
      return const SizedBox.shrink();
    }

    if (widget.weeksLeft == 0) {
      text = 'READY!';
    } else if (widget.isNew) {
      text = 'NEW!';
    }

    if (_isAnimationCompleted) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      );
    }

    return AnimatedTextKit(
      animatedTexts: [
        ScaleAnimatedText(
          text,
          textStyle: const TextStyle(
            fontSize: 8.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          duration: const Duration(milliseconds: 1000),
          scalingFactor: 1.1,
        ),
      ],
      repeatForever: text == 'READY!',
      isRepeatingAnimation: text == 'READY!',
      onFinished: text == 'NEW!'
          ? () {
              setState(() {
                _isAnimationCompleted = true;
              });
            }
          : null,
    );
  }
}
