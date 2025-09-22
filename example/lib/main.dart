import 'package:flutter/material.dart';
import 'package:json_inspector/json_inspector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Inspector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Example complex JSON data
  final Map<String, dynamic> complexJson = {
    "id": 123456,
    "user": {
      "name": "John Doe",
      "email": "john@example.com",
      "age": 30,
      "isVerified": true,
      "lastLogin": null,
      "address": {
        "street": "123 Main St",
        "city": "New York",
        "country": "USA",
        "coordinates": {"lat": 40.7128, "lng": -74.0060}
      }
    },
    "orders": [
      {
        "orderId": "ORD-001",
        "items": [
          {"productId": "P1", "name": "Laptop", "price": 999.99, "quantity": 1},
          {"productId": "P2", "name": "Mouse", "price": 29.99, "quantity": 2}
        ],
        "total": 1059.97,
        "status": "delivered"
      },
      {
        "orderId": "ORD-002",
        "items": [
          {"productId": "P3", "name": "Keyboard", "price": 79.99, "quantity": 1}
        ],
        "total": 79.99,
        "status": "pending"
      }
    ],
    "preferences": {
      "notifications": {"email": true, "push": false, "sms": true},
      "theme": "dark",
      "language": "en"
    },
    "tags": ["premium", "loyal-customer", "early-adopter"],
    "metadata": {
      "lastUpdated": "2024-03-12T10:30:00Z",
      "version": "2.0",
      "debug": {
        "sessionId": "sess_12345",
        "clientVersion": "1.2.3",
        "features": ["beta", "experimental"]
      }
    }
  };

  bool _expandAll = true;
  int _expansionDepth = -1;

  final List<int> _depthOptions = [-1, 1, 2, 3];
  final Map<int, String> _depthLabels = {
    -1: 'All levels',
    1: '1 level',
    2: '2 levels',
    3: '3 levels',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Inspector Example'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.settings),
            tooltip: 'Expansion Settings',
            onSelected: (int depth) {
              setState(() {
                _expansionDepth = depth;
                _expandAll = true; // Enable expansion when depth is selected
              });
            },
            itemBuilder: (BuildContext context) =>
                _depthOptions.map((int depth) {
              return PopupMenuItem<int>(
                value: depth,
                child: Row(
                  children: [
                    Icon(
                      _expansionDepth == depth ? Icons.check : Icons.layers,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text('Expand ${_depthLabels[depth]}'),
                  ],
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
            onPressed: () {
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            tooltip: _expandAll ? 'Collapse All' : 'Expand All',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Interactive JSON Viewer',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• Click arrows to expand/collapse\n'
                    '• Click anywhere to select\n'
                    '• Long press to copy values',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current expansion: ${_expandAll ? _depthLabels[_expansionDepth] : "Collapsed"}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                child: JsonInspector(
                  jsonData: complexJson,
                  initiallyExpanded: _expandAll,
                  expansionDepth: _expansionDepth,
                  keyStyle: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                  valueStyle: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
