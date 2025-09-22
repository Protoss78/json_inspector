# JSON Inspector

A Flutter package that provides an interactive JSON viewer with features like expanding/collapsing nodes, selecting values, and copying to clipboard. Perfect for debugging, data inspection, and JSON visualization needs.

[![pub package](https://img.shields.io/pub/v/json_inspector.svg)](https://pub.dev/packages/json_inspector)

## Features

- 🌳 Interactive tree view of JSON data
- 🔍 Expandable/collapsible nodes for objects and arrays
- ✨ Node selection with highlight
- 📋 Copy to clipboard functionality
- 🎨 Customizable styles for keys and values
- 📊 Visual indicators for array length and object key count
- 🎯 Support for all JSON data types
- 📱 Responsive and scrollable interface

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  json_inspector: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:json_inspector/json_inspector.dart';

// Your JSON data
final jsonData = {
  "name": "John Doe",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York"
  },
  "hobbies": ["reading", "gaming", "cooking"]
};

// Use it in your widget tree
JsonInspector(
  jsonData: jsonData,
  initiallyExpanded: true, // Optional: expand all nodes initially
  expansionDepth: 2, // Optional: control expansion depth (default: -1 for all levels)
)
```

### Customization

```dart
JsonInspector(
  jsonData: jsonData,
  initiallyExpanded: false,
  expansionDepth: 1, // Expand only first level when initiallyExpanded is true
  keyStyle: TextStyle(
    color: Colors.purple,
    fontWeight: FontWeight.bold,
  ),
  valueStyle: TextStyle(
    color: Colors.green,
  ),
)
```

## Features in Detail

### 1. Interactive Expansion
- Click on arrows to expand/collapse nodes
- Use `initiallyExpanded` parameter to control initial state
- Use `expansionDepth` parameter to control how deep the initial expansion goes:
  - `-1` (default): Expand all levels when `initiallyExpanded` is true
  - `1`: Expand only the first level
  - `2`: Expand up to the second level
  - And so on...

### 2. Selection and Copying
- Click anywhere on a line to select it
- Long press to copy the value to clipboard
- Visual feedback for selected items

### 3. Visual Indicators
- Arrays show item count: `[3 items]`
- Objects show key count: `{2 keys}`
- Color-coded keys and values for better readability

### 4. Type Support
- Null values
- Booleans
- Numbers
- Strings
- Arrays
- Objects

## Example

```dart
import 'package:flutter/material.dart';
import 'package:json_inspector/json_inspector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jsonData = {
      "user": {
        "id": 1,
        "name": "John Doe",
        "isActive": true,
        "favorites": [
          "pizza",
          "coding",
          null
        ]
      }
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('JSON Inspector Demo')),
        body: JsonInspector(
          jsonData: jsonData,
          initiallyExpanded: true,
          expansionDepth: 2, // Expand up to 2 levels deep
        ),
      ),
    );
  }
}
```

## Additional Information

### Requirements
- Dart SDK: ">=2.17.0 <4.0.0"
- Flutter: ">=3.0.0"

### Contributions
Contributions are welcome! If you find a bug or want a feature, please:
1. Open an issue
2. Create a pull request with your changes

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Getting Started with Development

1. Clone the repository:
    ```bash
    git clone https://github.com/Neelansh-ns/json_inspector.git
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the example:
    ```bash
    cd example
    flutter run
    ```

## Author
Neelansh Sethi
- GitHub: [@Neelansh-ns](https://github.com/Neelansh-ns)
- Twitter: [@neelansh_ns](https://x.com/neelansh_ns)

## Acknowledgments
- Inspired by various JSON viewers in developer tools
- Built with Flutter for the community