import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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
      bool shouldExpand =
          widget.initiallyExpanded && (widget.expansionDepth == -1 || currentDepth < widget.expansionDepth);
      _expandedState[path] = shouldExpand;
      _selectedState[path] = false;
      data.forEach((key, value) {
        _initializeStates(value, '$path/$key', currentDepth + 1);
      });
    } else if (data is List) {
      bool shouldExpand =
          widget.initiallyExpanded && (widget.expansionDepth == -1 || currentDepth < widget.expansionDepth);
      _expandedState[path] = shouldExpand;
      _selectedState[path] = false;
      for (var i = 0; i < data.length; i++) {
        _initializeStates(data[i], '$path/$i', currentDepth + 1);
      }
    }
  }

  Widget _buildJsonTree(dynamic data, String path, String key) {
    if (data == null) {
      return _buildLeafNode(null, 'null', path, key);
    } else if (data is num || data is bool) {
      return _buildLeafNode(data, data.toString(), path, key);
    } else if (data is String) {
      return _buildLeafNode(data, '"$data"', path, key);
    } else if (data is List) {
      return _buildListNode(data, path, key);
    } else if (data is Map) {
      return _buildMapNode(data, path, key);
    }
    return _buildLeafNode(data, data.toString(), path, key);
  }

  Widget _buildLeafNode(dynamic originalValue, String displayValue, String path, String key) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedState[path] = !(_selectedState[path] ?? false);
        });
      },
      onLongPress: () => _copyToClipboard(_toJsonString(originalValue)),
      child: Container(
        color: _selectedState[path] ?? false ? Colors.blue.withValues(alpha: 25.5) : null,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            const SizedBox(width: 24), // Space for consistency with expanded items
            Text(key, style: widget.keyStyle ?? const TextStyle(color: Colors.purple)),
            const Text(': '),
            Expanded(
              child: Text(
                displayValue,
                overflow: TextOverflow.ellipsis,
                style: widget.valueStyle ?? TextStyle(color: originalValue == null ? Colors.grey : Colors.green),
              ),
            ),
            Tooltip(
              message: 'Copy value',
              child: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  _copyToClipboard(_toJsonString(originalValue));
                  _showCopiedSnackBar('Copied value');
                },
              ),
            ),
            _buildOverflowMenu(path: path, keyLabel: key, node: originalValue),
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
          onLongPress: () => _copyToClipboard(_toJsonString(data)),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 24,
              ),
              Text(key, style: widget.keyStyle ?? const TextStyle(color: Colors.purple)),
              Text(': [${data.length} items]'),
              const Spacer(),
              Tooltip(
                message: 'Copy JSON',
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    _copyToClipboard(_toJsonString(data));
                    _showCopiedSnackBar('Copied array JSON');
                  },
                ),
              ),
              _buildOverflowMenu(path: path, keyLabel: key, node: data),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < data.length; i++) _buildJsonTree(data[i], '$path/$i', '[$i]'),
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
          onLongPress: () => _copyToClipboard(_toJsonString(data)),
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 24,
              ),
              Text(key, style: widget.keyStyle ?? const TextStyle(color: Colors.purple)),
              Text(
                ': {${data.length} keys}',
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Tooltip(
                message: 'Copy JSON',
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    _copyToClipboard(_toJsonString(data));
                    _showCopiedSnackBar('Copied object JSON');
                  },
                ),
              ),
              _buildOverflowMenu(path: path, keyLabel: key, node: data),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var entry in data.entries) _buildJsonTree(entry.value, '$path/${entry.key}', entry.key.toString()),
              ],
            ),
          ),
      ],
    );
  }

  String _toJsonString(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      // Fallback for non-encodable objects
      return data?.toString() ?? 'null';
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  void _showCopiedSnackBar(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildOverflowMenu({
    required String path,
    required String keyLabel,
    required dynamic node,
  }) {
    return PopupMenuButton<String>(
      tooltip: 'More actions',
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'copy_key',
          child: Text('Copy key'),
        ),
        PopupMenuItem<String>(
          value: 'copy_key_path',
          child: Text('Copy key path'),
        ),
        PopupMenuItem<String>(
          value: 'copy_json',
          child: Text('Copy JSON'),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'copy_key':
            _copyToClipboard(keyLabel);
            _showCopiedSnackBar('Copied key');
            break;
          case 'copy_key_path':
            final normalized = path.startsWith('/') ? path.substring(1) : path;
            _copyToClipboard(normalized);
            _showCopiedSnackBar('Copied key path');
            break;
          case 'copy_json':
            _copyToClipboard(_toJsonString(node));
            _showCopiedSnackBar('Copied JSON');
            break;
        }
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 4.0),
        child: Icon(Icons.more_vert, size: 18),
      ),
    );
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
