/// Formatting utilities for numbers, currency signs, and digit grouping separators.
class TickerFormatter {
  /// Formats a numeric value into a partitioned string with thousands separators
  /// and fixed decimal places.
  static String format(
    num value, {
    int fractionDigits = 2,
    bool useGrouping = true,
    String? prefix,
    String? suffix,
  }) {
    final isNegative = value < 0;
    final absValue = value.abs();

    String formattedNumber;
    if (fractionDigits > 0) {
      formattedNumber = absValue.toStringAsFixed(fractionDigits);
    } else {
      formattedNumber = absValue.round().toString();
    }

    final parts = formattedNumber.split('.');
    String integerPart = parts[0];
    final String decimalPart = parts.length > 1 ? parts[1] : '';

    if (useGrouping) {
      final buffer = StringBuffer();
      final length = integerPart.length;
      for (int i = 0; i < length; i++) {
        if (i > 0 && (length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(integerPart[i]);
      }
      integerPart = buffer.toString();
    }

    final result = StringBuffer();
    if (isNegative) result.write('-');
    if (prefix != null) result.write(prefix);
    result.write(integerPart);
    if (decimalPart.isNotEmpty) {
      result.write('.');
      result.write(decimalPart);
    }
    if (suffix != null) result.write(suffix);

    return result.toString();
  }

  /// Formats large numbers compactly (e.g. 1.2K, 4.5M, 1.2B).
  static String formatCompact(
    num value, {
    String? prefix,
    String? suffix,
  }) {
    final absVal = value.abs();
    final isNeg = value < 0;

    String numStr;
    String symbol = '';

    if (absVal >= 1000000000) {
      numStr = (absVal / 1000000000).toStringAsFixed(1);
      symbol = 'B';
    } else if (absVal >= 1000000) {
      numStr = (absVal / 1000000).toStringAsFixed(1);
      symbol = 'M';
    } else if (absVal >= 1000) {
      numStr = (absVal / 1000).toStringAsFixed(1);
      symbol = 'K';
    } else {
      numStr = absVal.toStringAsFixed(0);
    }

    // Clean .0 suffix (e.g. 1.0M -> 1M)
    if (numStr.endsWith('.0')) {
      numStr = numStr.substring(0, numStr.length - 2);
    }

    final buffer = StringBuffer();
    if (isNeg) buffer.write('-');
    if (prefix != null) buffer.write(prefix);
    buffer.write(numStr);
    buffer.write(symbol);
    if (suffix != null) buffer.write(suffix);

    return buffer.toString();
  }
}
