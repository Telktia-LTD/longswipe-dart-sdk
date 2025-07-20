/// Types of responses that can be received from the Longswipe widget
enum ResponseType {
  /// Widget operation completed successfully
  success,

  /// An error occurred during widget operation
  error,

  /// Widget was closed by the user
  close,

  /// Widget has started and is ready
  start,

  /// Widget is loading
  loading,
}

/// Extension on ResType to convert to and from strings
extension ResTypeExtension on ResponseType {
  /// Convert ResType to string
  String toValue() {
    switch (this) {
      case ResponseType.success:
        return 'success';
      case ResponseType.error:
        return 'error';
      case ResponseType.close:
        return 'close';
      case ResponseType.start:
        return 'start';
      case ResponseType.loading:
        return 'loading';
    }
  }

  /// Convert string to ResType
  static ResponseType fromValue(String value) {
    switch (value) {
      case 'success':
        return ResponseType.success;
      case 'error':
        return ResponseType.error;
      case 'close':
        return ResponseType.close;
      case 'start':
        return ResponseType.start;
      case 'loading':
        return ResponseType.loading;
      default:
        throw ArgumentError('Invalid ResType value: $value');
    }
  }
}
