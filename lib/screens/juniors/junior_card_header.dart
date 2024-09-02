import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class JuniorRow extends StatefulWidget {
  final String juniorFullName;
  final bool isExpanded;
  final int weeksLeft;
  final bool isNew;

  const JuniorRow({
    super.key,
    required this.juniorFullName,
    required this.isExpanded,
    required this.weeksLeft,
    required this.isNew,
  });

  @override
  State<JuniorRow> createState() => _JuniorRowState();
}

class _JuniorRowState extends State<JuniorRow> {
  bool _isAnimationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.juniorFullName,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.weeksLeft == 0 || widget.isNew) _buildAnimatedOrStaticText(),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
          child: Align(
            alignment: Alignment.topRight,
            child: Icon(
              widget.isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedOrStaticText() {
    String text = '';

    if (widget.weeksLeft == 0) {
      text = 'READY!';
    } else if (widget.isNew) {
      text = 'NEW!';
    }

    if (_isAnimationCompleted) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
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
            fontSize: 16.0,
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
