import 'package:flutter/material.dart';

/// An individual mechanical cylinder column that rolls vertically to display a target digit.
class DigitCylinder extends StatefulWidget {
  final String char;
  final TextStyle style;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final bool isRollingUp;

  const DigitCylinder({
    super.key,
    required this.char,
    required this.style,
    required this.duration,
    required this.curve,
    this.delay = Duration.zero,
    this.isRollingUp = true,
  });

  @override
  State<DigitCylinder> createState() => _DigitCylinderState();
}

class _DigitCylinderState extends State<DigitCylinder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  int _previousDigit = 0;
  int _targetDigit = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final int? initial = int.tryParse(widget.char);
    _targetDigit = initial ?? 0;
    _previousDigit = _targetDigit;

    _animation = Tween<double>(
      begin: _targetDigit.toDouble(),
      end: _targetDigit.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(covariant DigitCylinder oldWidget) {
    super.didUpdateWidget(oldWidget);

    final int? newParsed = int.tryParse(widget.char);
    if (newParsed != null && newParsed != _targetDigit) {
      _previousDigit = _targetDigit;
      _targetDigit = newParsed;

      _controller.duration = widget.duration;

      // Handle roll physics: if rolling up and wrap around
      double start = _previousDigit.toDouble();
      double end = _targetDigit.toDouble();

      if (widget.isRollingUp && end < start) {
        end += 10;
      } else if (!widget.isRollingUp && end > start) {
        start += 10;
      }

      _animation = Tween<double>(begin: start, end: end).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );

      _controller.reset();
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Size _measureCharSize(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: '8', style: widget.style),
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    final int? isDigit = int.tryParse(widget.char);

    // If non-digit symbol (comma, period, currency sign), display static without roll
    if (isDigit == null) {
      return Text(widget.char, style: widget.style);
    }

    final charSize = _measureCharSize(context);
    final double digitHeight = charSize.height > 0 ? charSize.height : 24.0;
    final double digitWidth = charSize.width > 0 ? charSize.width : 14.0;

    return SizedBox(
      width: digitWidth,
      height: digitHeight,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final double currentVal = _animation.value % 10.0;
            return Stack(
              children: List.generate(10, (index) {
                // Calculate vertical offset relative to current position
                double diff = index - currentVal;
                if (diff < -5) diff += 10;
                if (diff > 5) diff -= 10;

                final double yOffset = diff * digitHeight;

                // Only render digits in close vertical proximity for performance
                if (yOffset.abs() > digitHeight * 1.5) {
                  return const SizedBox.shrink();
                }

                return Transform.translate(
                  offset: Offset(0, yOffset),
                  child: Center(
                    child: Text(
                      index.toString(),
                      style: widget.style,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
