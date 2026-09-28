import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolling_number_ticker/rolling_number_ticker.dart';

void main() {
  runApp(const RollingTickerExampleApp());
}

class RollingTickerExampleApp extends StatelessWidget {
  const RollingTickerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolling Number Ticker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          surface: Color(0xFF131924),
        ),
        useMaterial3: true,
      ),
      home: const FintechTickerShowcaseScreen(),
    );
  }
}

class FintechTickerShowcaseScreen extends StatefulWidget {
  const FintechTickerShowcaseScreen({super.key});

  @override
  State<FintechTickerShowcaseScreen> createState() =>
      _FintechTickerShowcaseScreenState();
}

class _FintechTickerShowcaseScreenState
    extends State<FintechTickerShowcaseScreen> {
  double _portfolioValue = 124892.45;
  double _btcPrice = 67450.80;
  int _counterValue = 1042;
  num _compactFollowers = 1420000;

  Timer? _liveTickerTimer;
  bool _isAutoLive = false;

  @override
  void dispose() {
    _liveTickerTimer?.cancel();
    super.dispose();
  }

  void _toggleAutoTick() {
    setState(() {
      _isAutoLive = !_isAutoLive;
      if (_isAutoLive) {
        final random = math.Random();
        _liveTickerTimer =
            Timer.periodic(const Duration(milliseconds: 1400), (_) {
          final deltaBtc = (random.nextDouble() - 0.48) * 120.0;
          final deltaPort = (random.nextDouble() - 0.48) * 350.0;

          setState(() {
            _btcPrice = (_btcPrice + deltaBtc).clamp(60000.0, 75000.0);
            _portfolioValue = (_portfolioValue + deltaPort).clamp(50000.0, 200000.0);
          });
        });
      } else {
        _liveTickerTimer?.cancel();
        _liveTickerTimer = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rolling Number Ticker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F1520),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _isAutoLive ? 'Pause Auto-Tick' : 'Start Auto-Tick',
            icon: Icon(
              _isAutoLive ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              color: _isAutoLive ? const Color(0xFF10B981) : Colors.white70,
            ),
            onPressed: _toggleAutoTick,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // 1. Robinhood / CashApp Total Portfolio Balance Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF161E2E), Color(0xFF0F1622)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1F293D)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Investing Portfolio',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isAutoLive ? const Color(0x3310B981) : Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _isAutoLive ? 'LIVE FEED' : 'STATIC',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _isAutoLive ? const Color(0xFF10B981) : Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RollingNumberTicker(
                    value: _portfolioValue,
                    prefix: '\$',
                    fractionDigits: 2,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontFamily: 'monospace',
                    ),
                    enableTrendGlow: true,
                    trendUpColor: const Color(0xFF10B981),
                    trendDownColor: const Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981).withAlpha(40),
                          foregroundColor: const Color(0xFF10B981),
                        ),
                        onPressed: () => setState(() => _portfolioValue += 250.75),
                        child: const Text('+\$250'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444).withAlpha(40),
                          foregroundColor: const Color(0xFFEF4444),
                        ),
                        onPressed: () => setState(() => _portfolioValue -= 180.50),
                        child: const Text('-\$180'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Crypto Live Price Ticker Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121926),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E2838)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFF59E0B),
                        child: Text(
                          '₿',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bitcoin',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'BTC / USD',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RollingNumberTicker(
                    value: _btcPrice,
                    prefix: '\$',
                    fractionDigits: 2,
                    duration: const Duration(milliseconds: 650),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Increment / Decrement Counter Reel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121926),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E2838)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mechanical Counter Reel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: RollingNumberTicker(
                      value: _counterValue,
                      fractionDigits: 0,
                      curve: Curves.easeOutBack,
                      duration: const Duration(milliseconds: 600),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove_rounded),
                        onPressed: () => setState(() => _counterValue -= 1),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add_rounded),
                        onPressed: () => setState(() => _counterValue += 1),
                      ),
                      const SizedBox(width: 18),
                      OutlinedButton(
                        onPressed: () => setState(() => _counterValue += 100),
                        child: const Text('+100'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Compact Notation (1.4M Followers)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121926),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E2838)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Social Followers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      RollingNumberTicker(
                        value: _compactFollowers,
                        isCompact: true,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA855F7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.favorite_rounded, color: Color(0xFFEC4899)),
                        onPressed: () => setState(() => _compactFollowers += 100000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
