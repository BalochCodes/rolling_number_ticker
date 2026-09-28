import 'package:flutter_test/flutter_test.dart';
import 'package:rolling_number_ticker/rolling_number_ticker.dart';

void main() {
  group('TickerFormatter Tests', () {
    test('Formats decimal numbers with standard currency and thousands grouping', () {
      final result = TickerFormatter.format(
        1250450.75,
        fractionDigits: 2,
        useGrouping: true,
        prefix: '\$',
      );
      expect(result, equals('\$1,250,450.75'));
    });

    test('Formats zero and negative numbers cleanly', () {
      final zeroResult = TickerFormatter.format(0, fractionDigits: 2, prefix: '\$');
      expect(zeroResult, equals('\$0.00'));

      final negResult = TickerFormatter.format(-450.5, fractionDigits: 2, prefix: '\$');
      expect(negResult, equals('-\$450.50'));
    });

    test('Formats integer without decimals when fractionDigits is 0', () {
      final result = TickerFormatter.format(
        9876543,
        fractionDigits: 0,
        useGrouping: true,
      );
      expect(result, equals('9,876,543'));
    });

    test('formatCompact formats thousands, millions, and billions', () {
      expect(TickerFormatter.formatCompact(850, prefix: '\$'), equals('\$850'));
      expect(TickerFormatter.formatCompact(1500, prefix: '\$'), equals('\$1.5K'));
      expect(TickerFormatter.formatCompact(4200000, prefix: '\$'), equals('\$4.2M'));
      expect(TickerFormatter.formatCompact(2500000000, prefix: '\$'), equals('\$2.5B'));
    });
  });
}
