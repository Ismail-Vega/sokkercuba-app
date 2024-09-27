import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class JuniorBadge extends StatefulWidget {
  final int weeksLeft;
  final bool isNew;
  final bool showAnimation;
  final bool isCrack;

  const JuniorBadge({
    super.key,
    required this.weeksLeft,
    required this.isNew,
    required this.showAnimation,
    required this.isCrack,
  });

  @override
  State<JuniorBadge> createState() => _JuniorBadgeState();
}

class _JuniorBadgeState extends State<JuniorBadge> {
  bool _isAnimationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.showAnimation) {
      return const SizedBox.shrink();
    }

    String baseText = '';
    if (widget.weeksLeft == 0) {
      baseText = 'READY!';
    } else if (widget.isNew) {
      baseText = 'NEW!';
    }

    final fullText = widget.isCrack ? 'CRACK! $baseText' : baseText;

    if (_isAnimationCompleted) {
      return Text(
        fullText,
        style: const TextStyle(
          fontSize: 8.0,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      );
    }

    final bool shouldRepeat = widget.weeksLeft == 0;

    return AnimatedTextKit(
      animatedTexts: [
        ScaleAnimatedText(
          fullText,
          textStyle: const TextStyle(
            fontSize: 8.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          duration: const Duration(milliseconds: 2000),
          scalingFactor: 0.5,
        ),
      ],
      repeatForever: shouldRepeat,
      isRepeatingAnimation: shouldRepeat,
      onFinished: shouldRepeat
          ? null
          : () {
              setState(() {
                _isAnimationCompleted = true;
              });
            },
    );
  }
}
