/// Types of responses that can be received from the Longswipe widget
enum ResType {
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
extension ResTypeExtension on ResType {
  /// Convert ResType to string
  String toValue() {
    switch (this) {
      case ResType.success:
        return 'success';
      case ResType.error:
        return 'error';
      case ResType.close:
        return 'close';
      case ResType.start:
        return 'start';
      case ResType.loading:
        return 'loading';
    }
  }
  
  /// Convert string to ResType
  static ResType fromValue(String value) {
    switch (value) {
      case 'success':
        return ResType.success;
      case 'error':
        return ResType.error;
      case 'close':
        return ResType.close;
      case 'start':
        return ResType.start;
      case 'loading':
        return ResType.loading;
      default:
        throw ArgumentError('Invalid ResType value: $value');
    }
  }
}
