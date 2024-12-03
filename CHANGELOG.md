# Changelog

## 0.0.3 - 2024-03-15

### Updated README.md

## 0.0.1 - 2024-03-12

### Added
- Initial release of the JSON Inspector package
- Core JSON visualization functionality
    - Interactive tree view of JSON data
    - Expandable/collapsible nodes for objects and arrays
    - Node selection with highlight
    - Copy to clipboard functionality
    - Visual indicators for array length and object key count
    - Color-coded keys and values
    - Support for all JSON data types (null, boolean, number, string, array, object)

### Features
- Customizable styles for keys and values through `keyStyle` and `valueStyle` parameters
- Option to set initial expansion state through `initiallyExpanded` parameter
- Long press gesture to copy values to clipboard
- Automatic indentation for nested structures
- Visual feedback for selected items
- Built-in scroll support for large JSON structures

### Documentation
- Added comprehensive README with usage examples
- Included example project demonstrating key features
- Added inline documentation for all public APIs