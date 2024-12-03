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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Inspector Example'),
        actions: [
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '• Click arrows to expand/collapse\n'
                '• Click anywhere to select\n'
                '• Long press to copy values',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: Card(
                child: JsonInspector(
                  jsonData: complexJson,
                  initiallyExpanded: _expandAll,
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
