import 'package:flutter/material.dart';

class FutureProgressBar extends StatefulWidget {
  final double currentProgress;
  final double futureProgress;

  const FutureProgressBar({
    super.key,
    required this.currentProgress,
    required this.futureProgress,
  });

  @override
  State<FutureProgressBar> createState() => _FutureProgressBarState();
}

class _FutureProgressBarState extends State<FutureProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double barHeight = 10.0;
    double fontSize = 6.0;

    if (screenWidth <= 600 && screenWidth >= 464) {
      fontSize = 8.0;
    } else if (screenWidth > 600 && screenWidth <= 764) {
      barHeight = 12.0;
      fontSize = 10.0;
    } else if (screenWidth > 764) {
      barHeight = 16.0;
      fontSize = 12.0;
    }

    final totalProgress = widget.currentProgress + widget.futureProgress;
    final currentProgressFraction = widget.currentProgress / 100;
    final futureProgressFraction = totalProgress > 100
        ? (100 - widget.currentProgress) / 100
        : widget.futureProgress / 100;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: barHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[400],
          ),
        ),
        FractionallySizedBox(
          widthFactor: currentProgressFraction,
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.green,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final animatedFutureProgress = currentProgressFraction +
                (futureProgressFraction * _controller.value);
            return FractionallySizedBox(
              widthFactor: animatedFutureProgress,
              child: Container(
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.withOpacity(0.5),
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '${widget.currentProgress.toInt()}%',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
