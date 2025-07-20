import 'response_types.dart';

/// Supported currencies for Longswipe
enum Currency {
  NGN,
  USDT,
  USDC,
  EURC,
}

enum Environment {
  production,
  sandbox,
}

/// Extension on Currency to convert to string
extension CurrencyExtension on Currency {
  String toValue() => toString().split('.').last;
}

/// Extension on Environment to convert to string
extension EnvironmentExtension on Environment {
  String toValue() => toString().split('.').last;
}

/// Options for the Longswipe widget
class LongswipeOptions {
  /// Your Longswipe API key
  final String apiKey;

  final Environment? environment;

  /// Unique identifier for the transaction
  final String referenceId;

  /// Default currency for redemption
  final Currency? defaultCurrency;

  /// Default amount for redemption
  final double? defaultAmount;

  /// Additional configuration options
  final Map<String, dynamic>? config;

  /// Metadata to pass to the widget
  final Map<String, dynamic>? metaData;

  /// Constructor
  LongswipeOptions({
    required this.apiKey,
    required this.referenceId,
    required this.environment,
    this.defaultCurrency,
    this.defaultAmount,
    this.config,
    this.metaData,
  });

  /// Convert to a map that can be passed to JavaScript
  Map<String, dynamic> toMap() {
    return {
      'apiKey': apiKey,
      'referenceId': referenceId,
      'environment': environment!.toValue(),
      if (defaultCurrency != null)
        'defaultCurrency': defaultCurrency!.toValue(),
      if (defaultAmount != null) 'defaultAmount': defaultAmount,
      if (config != null) 'config': config,
      if (metaData != null) 'metaData': metaData,
    };
  }
}

/// Options for the Longswipe controller
class LongswipeControllerOptions extends LongswipeOptions {
  /// Callback function for widget events
  final void Function(ResponseType type, dynamic data) onResponse;

  /// Constructor
  LongswipeControllerOptions({
    required super.apiKey,
    required super.environment,
    required super.referenceId,
    required this.onResponse,
    super.defaultCurrency,
    super.defaultAmount,
    super.config,
    super.metaData,
  });
}

/// Response from the Longswipe widget
class LongswipeResponse {
  /// The type of response
  final ResponseType type;

  /// The data associated with the response (if any)
  final dynamic data;

  /// Constructor
  LongswipeResponse({
    required this.type,
    this.data,
  });
}
