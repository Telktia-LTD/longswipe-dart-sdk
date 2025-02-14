class LongswipeException implements Exception {
  final String message;
  final int? code;
  final dynamic data;

  LongswipeException({
    required this.message,
    this.code,
    this.data,
  });

  @override
  String toString() => 'LongswipeException: $message';
}
