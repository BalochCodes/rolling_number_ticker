import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rolling_number_ticker/rolling_number_ticker.dart';

void main() {
  group('RollingNumberTicker Widget Tests', () {
    testWidgets('Renders formatted currency symbols and cylinders',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: RollingNumberTicker(
                value: 1250.50,
                prefix: '\$',
                fractionDigits: 2,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RollingNumberTicker), findsOneWidget);
      expect(find.byType(DigitCylinder), findsWidgets);
      expect(find.text('\$'), findsOneWidget);
      expect(find.text('.'), findsOneWidget);
      expect(find.text(','), findsOneWidget);
    });

    testWidgets('Updates cylinders smoothly when value increases and completes',
        (WidgetTester tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RollingNumberTicker(
                value: 100,
                duration: const Duration(milliseconds: 200),
                onComplete: () => completed = true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RollingNumberTicker), findsOneWidget);

      // Rebuild with higher value
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RollingNumberTicker(
                value: 250,
                duration: const Duration(milliseconds: 200),
                onComplete: () => completed = true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(completed, isTrue);
    });

    testWidgets('Renders compact notation correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: RollingNumberTicker(
                value: 1500000,
                isCompact: true,
                prefix: '\$',
              ),
            ),
          ),
        ),
      );

      expect(find.text('\$'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
    });
  });
}
