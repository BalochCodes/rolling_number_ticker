import 'package:flutter/material.dart';
import 'digit_cylinder.dart';
import 'ticker_formatter.dart';

/// A Robinhood & CashApp style mechanical vertical rolling number ticker
/// featuring independent rolling digit reels, directional roll physics,
/// and responsive delta trend glow pulses.
class RollingNumberTicker extends StatefulWidget {
  /// The target numeric value to display and roll towards.
  final num value;

  /// Optional prefix string (e.g. `'$'`, `'€'`, `'+'`).
  final String? prefix;

  /// Optional suffix string (e.g. `' USD'`, `'%'`, `' coins'`).
  final String? suffix;

  /// Number of decimal digits to retain (e.g. `2` for currency `$12.50`). Defaults to `2`.
  final int fractionDigits;

  /// Whether thousands commas are inserted (e.g. `1,250.00`). Defaults to `true`.
  final bool useGrouping;

  /// Whether to format large numbers compactly (e.g. `1.2M`, `45.8K`). Defaults to `false`.
  final bool isCompact;

  /// Text style applied across all digits and symbols.
  final TextStyle? style;

  /// Total duration of the rolling transition per digit cylinder. Defaults to 750ms.
  final Duration duration;

  /// Easing curve of the mechanical roll animation. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Staggered delay applied across consecutive digit reels from left-to-right.
  final Duration staggerDuration;

  /// Whether a subtle color flash or glow pulses when the value increases or decreases.
  final bool enableTrendGlow;

  /// Glow color pulsed when the new value is greater than the previous value.
  final Color trendUpColor;

  /// Glow color pulsed when the new value is less than the previous value.
  final Color trendDownColor;

  /// Duration of the trend color flash pulse. Defaults to 1000ms.
  final Duration trendGlowDuration;

  /// Horizontal and vertical alignment of the number string.
  final Alignment alignment;

  /// Optional callback invoked when the roll transition completes.
  final VoidCallback? onComplete;

  const RollingNumberTicker({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.fractionDigits = 2,
    this.useGrouping = true,
    this.isCompact = false,
    this.style,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.easeOutCubic,
    this.staggerDuration = const Duration(milliseconds: 30),
    this.enableTrendGlow = true,
    this.trendUpColor = const Color(0xFF10B981),
    this.trendDownColor = const Color(0xFFEF4444),
    this.trendGlowDuration = const Duration(milliseconds: 1000),
    this.alignment = Alignment.center,
    this.onComplete,
  });

  @override
  State<RollingNumberTicker> createState() => _RollingNumberTickerState();
}

class _RollingNumberTickerState extends State<RollingNumberTicker>
    with SingleTickerProviderStateMixin {
  bool _isRollingUp = true;

  late final AnimationController _glowController;
  Animation<Color?>? _glowColorAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: widget.trendGlowDuration,
    );
  }

  @override
  void didUpdateWidget(covariant RollingNumberTicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      final double delta = (widget.value - oldWidget.value).toDouble();
      _isRollingUp = delta >= 0;

      if (widget.enableTrendGlow && delta != 0) {
        final targetColor = _isRollingUp ? widget.trendUpColor : widget.trendDownColor;
        final baseColor = widget.style?.color ?? Colors.white;

        _glowColorAnimation = ColorTween(
          begin: targetColor,
          end: baseColor,
        ).animate(CurvedAnimation(
          parent: _glowController,
          curve: Curves.easeOut,
        ));

        _glowController.reset();
        _glowController.forward();
      }

      if (widget.onComplete != null) {
        Future.delayed(widget.duration, widget.onComplete);
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  String _formatValue() {
    if (widget.isCompact) {
      return TickerFormatter.formatCompact(
        widget.value,
        prefix: widget.prefix,
        suffix: widget.suffix,
      );
    }
    return TickerFormatter.format(
      widget.value,
      fractionDigits: widget.fractionDigits,
      useGrouping: widget.useGrouping,
      prefix: widget.prefix,
      suffix: widget.suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    final effectiveBaseStyle = widget.style != null
        ? defaultStyle.merge(widget.style)
        : defaultStyle;

    final formattedString = _formatValue();
    final chars = formattedString.split('');

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final Color? animatedColor = _glowColorAnimation?.value;
        final effectiveStyle = animatedColor != null
            ? effectiveBaseStyle.copyWith(color: animatedColor)
            : effectiveBaseStyle;

        return Align(
          alignment: widget.alignment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(chars.length, (index) {
              final char = chars[index];
              final delay = Duration(
                milliseconds: widget.staggerDuration.inMilliseconds * index,
              );

              return DigitCylinder(
                key: ValueKey('digit_${chars.length - index}_$char'),
                char: char,
                style: effectiveStyle,
                duration: widget.duration,
                curve: widget.curve,
                delay: delay,
                isRollingUp: _isRollingUp,
              );
            }),
          ),
        );
      },
    );
  }
}
