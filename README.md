# rolling_number_ticker 🎰

A mechanical slot-machine vertical rolling number ticker for Flutter with directional physics, trend glow pulses, and currency formatting.

[![pub package](https://img.shields.io/pub/v/rolling_number_ticker.svg)](https://pub.dev/packages/rolling_number_ticker)
[![pub points](https://img.shields.io/pub/points/rolling_number_ticker?color=2E8B57&label=pub%20points)](https://pub.dev/packages/rolling_number_ticker/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/BalochCodes/rolling_number_ticker?style=social)](https://github.com/BalochCodes/rolling_number_ticker)

Transform abrupt, jumpy numeric updates into smooth, physical rolling cylinder transitions inspired by Robinhood and CashApp fintech balance tickers. Each digit column rolls independently with physics-based momentum, directional logic, and delta trend color flashes.

---

## ✨ Features

- 🎰 **Mechanical Slot-Machine Reels:** Individual vertical cylinder columns for each numeric digit rolling smoothly into place.
- 🎯 **Directional Roll Physics:** Rolls upwards on value increases, and rolls downwards when the value decreases.
- 💡 **Delta Trend Glow:** Built-in subtle color pulse (emerald green on increase, crimson red on decrease).
- 🔠 **Static Symbol Pass-Through:** Currency symbols (`$`, `€`, `PKR`), commas, and decimals stay stationary while only digits roll.
- ⏱️ **Staggered Delays:** Configurable stagger delays across digits create an authentic cascading mechanical reel effect.
- 🔢 **Built-in Number Formatting:** Precision decimal control, thousands grouping, and compact notation (`1.4M`, `250K`).
- 🎨 **Deep Customization:** Customizable font styling, animation durations, and easing curves (e.g. `Curves.easeOutCubic`, `Curves.elasticOut`).

---

## 📦 Installation

Add `rolling_number_ticker` to your Flutter project:

```bash
flutter pub add rolling_number_ticker
```

Or add it directly to your `pubspec.yaml`:

```yaml
dependencies:
  rolling_number_ticker: ^0.0.1
```

---

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:rolling_number_ticker/rolling_number_ticker.dart';

class BalanceCard extends StatelessWidget {
  final double currentBalance;

  const BalanceCard({super.key, required this.currentBalance});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RollingNumberTicker(
        value: currentBalance,
        prefix: '\$',
        fractionDigits: 2,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
```

---

## 💡 Advanced Examples

### 1. Live Crypto Price Ticker with Trend Glow

```dart
RollingNumberTicker(
  value: btcPrice,
  prefix: '\$',
  fractionDigits: 2,
  duration: const Duration(milliseconds: 650),
  enableTrendGlow: true,
  trendUpColor: const Color(0xFF10B981),
  trendDownColor: const Color(0xFFEF4444),
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'monospace',
  ),
)
```

### 2. Compact Social Counter (e.g. 1.4M)

```dart
RollingNumberTicker(
  value: 1420000,
  isCompact: true,
  style: const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Color(0xFFA855F7),
  ),
)
```

### 3. Elastic Springy Score Reel

```dart
RollingNumberTicker(
  value: userScore,
  fractionDigits: 0,
  curve: Curves.elasticOut,
  duration: const Duration(milliseconds: 900),
  style: const TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: Color(0xFF38BDF8),
  ),
)
```

---

## ⚙️ Properties & Customization

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `num` | *required* | The target numeric value to roll towards. |
| `prefix` | `String?` | `null` | Preceding symbol (e.g. `'$'`, `'€'`). |
| `suffix` | `String?` | `null` | Trailing symbol (e.g. `' USD'`, `'%'`). |
| `fractionDigits` | `int` | `2` | Fixed decimal places to display. |
| `useGrouping` | `bool` | `true` | Adds thousands commas (e.g. `1,250.00`). |
| `isCompact` | `bool` | `false` | Enables compact notation (`1.2M`, `45K`). |
| `style` | `TextStyle?` | `null` | Text typography and base color. |
| `duration` | `Duration` | `750ms` | Duration of the mechanical roll animation. |
| `curve` | `Curve` | `Curves.easeOutCubic` | Animation easing curve. |
| `staggerDuration` | `Duration` | `30ms` | Delay increment between digit columns. |
| `enableTrendGlow` | `bool` | `true` | Pulses green on increase, red on decrease. |
| `trendUpColor` | `Color` | `Color(0xFF10B981)` | Color flash on positive change. |
| `trendDownColor` | `Color` | `Color(0xFFEF4444)` | Color flash on negative change. |
| `trendGlowDuration`| `Duration` | `1000ms` | Duration of trend color flash decay. |
| `alignment` | `Alignment` | `Alignment.center` | Layout alignment of the ticker string. |
| `onComplete` | `VoidCallback?` | `null` | Invoked when the roll animation ends. |

---

## 🖼️ Example Showcase

Check out the interactive fintech portfolio and crypto price ticker in [`example/lib/main.dart`](example/lib/main.dart).

---

## 🤝 Contributing

Contributions, bug reports, and suggestions are welcome! Feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/BalochCodes/rolling_number_ticker).

---

## 📄 License

This package is licensed under the MIT License. See [LICENSE](LICENSE) for details.

Copyright (c) 2026 BalochCodes.

---

## 👨‍💻 Author

Developed with ❤️ by **Shahzain Baloch** ([BalochCodes](https://github.com/BalochCodes)).
