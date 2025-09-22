import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget for displaying and interacting with JSON data.
/// Provides features like expanding/collapsing nodes, selecting values, and copying to the clipboard.
class JsonInspector extends StatefulWidget {
  ///The json data to be displayed.
  final dynamic jsonData;

  /// Whether the JSON nodes should be initially expanded.
  final bool initiallyExpanded;

  /// The depth level to expand when initiallyExpanded is true.
  /// -1 means expand all levels, 1 means expand only first level, etc.
  final int expansionDepth;

  /// Custom text style for JSON keys.

  final TextStyle? keyStyle;

  /// Custom text style for JSON values.

  final TextStyle? valueStyle;

  /// Creates a [JsonInspector] widget.
  const JsonInspector({
    super.key,
    required this.jsonData,
    this.initiallyExpanded = false,
    this.expansionDepth = -1,
    this.keyStyle,
    this.valueStyle,
  });

  @override
  State<JsonInspector> createState() => _JsonInspectorState();
}

class _JsonInspectorState extends State<JsonInspector> {
  late Map<String, bool> _expandedState;
  late Map<String, bool> _selectedState;

  @override
  void initState() {
    super.initState();
    _expandedState = {};
    _selectedState = {};
    _initializeStates(widget.jsonData, '', 0);
  }

  @override
  void didUpdateWidget(covariant JsonInspector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.jsonData != widget.jsonData ||
        oldWidget.initiallyExpanded != widget.initiallyExpanded ||
        oldWidget.expansionDepth != widget.expansionDepth) {
      _expandedState = {};
      _selectedState = {};
      _initializeStates(widget.jsonData, '', 0);
    }
  }

  void _initializeStates(dynamic data, String path, int currentDepth) {
    if (data is Map) {
      bool shouldExpand = widget.initiallyExpanded &&
          (widget.expansionDepth == -1 || currentDepth < widget.expansionDepth);
      _expandedState[path] = shouldExpand;
      _selectedState[path] = false;
      data.forEach((key, value) {
        _initializeStates(value, '$path/$key', currentDepth + 1);
      });
    } else if (data is List) {
      bool shouldExpand = widget.initiallyExpanded &&
          (widget.expansionDepth == -1 || currentDepth < widget.expansionDepth);
      _expandedState[path] = shouldExpand;
      _selectedState[path] = false;
      for (var i = 0; i < data.length; i++) {
        _initializeStates(data[i], '$path/$i', currentDepth + 1);
      }
    }
  }

  Widget _buildJsonTree(dynamic data, String path, String key) {
    if (data == null) {
      return _buildLeafNode('null', path, key);
    } else if (data is num || data is bool) {
      return _buildLeafNode(data.toString(), path, key);
    } else if (data is String) {
      return _buildLeafNode('"$data"', path, key);
    } else if (data is List) {
      return _buildListNode(data, path, key);
    } else if (data is Map) {
      return _buildMapNode(data, path, key);
    }
    return _buildLeafNode(data.toString(), path, key);
  }

  Widget _buildLeafNode(String value, String path, String key) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedState[path] = !(_selectedState[path] ?? false);
        });
      },
      onLongPress: () => _copyToClipboard(value),
      child: Container(
        color: _selectedState[path] ?? false
            ? Colors.blue.withValues(alpha: 25.5)
            : null,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            const SizedBox(
                width: 24), // Space for consistency with expanded items
            Text(key,
                style:
                    widget.keyStyle ?? const TextStyle(color: Colors.purple)),
            const Text(': '),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: widget.valueStyle ??
                    TextStyle(
                        color: value == 'null' ? Colors.grey : Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListNode(List data, String path, String key) {
    bool isExpanded = _expandedState[path] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedState[path] = !isExpanded;
            });
          },
          onLongPress: () => _copyToClipboard(data.toString()),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 24,
              ),
              Text(key,
                  style:
                      widget.keyStyle ?? const TextStyle(color: Colors.purple)),
              Text(': [${data.length} items]'),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < data.length; i++)
                  _buildJsonTree(data[i], '$path/$i', '[$i]'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMapNode(Map data, String path, String key) {
    bool isExpanded = _expandedState[path] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedState[path] = !isExpanded;
            });
          },
          onLongPress: () => _copyToClipboard(data.toString()),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 24,
              ),
              Text(key,
                  style:
                      widget.keyStyle ?? const TextStyle(color: Colors.purple)),
              Text(
                ': {${data.length} keys}',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var entry in data.entries)
                  _buildJsonTree(
                      entry.value, '$path/${entry.key}', entry.key.toString()),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildJsonTree(widget.jsonData, '', 'root'),
      ),
    );
  }
}
