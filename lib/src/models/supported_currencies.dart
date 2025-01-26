import 'dart:convert';

SupportedCurrencies supportedCurrenciesFromJson(String str) =>
    SupportedCurrencies.fromJson(json.decode(str));

String supportedCurrenciesToJson(SupportedCurrencies data) =>
    json.encode(data.toJson());

class SupportedCurrencies {
  String message;
  int code;
  String status;
  CurrenciesData data;

  SupportedCurrencies({
    required this.message,
    required this.code,
    required this.status,
    required this.data,
  });

  factory SupportedCurrencies.fromJson(Map<String, dynamic> json) =>
      SupportedCurrencies(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        data: CurrenciesData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "data": data.toJson(),
      };
}

class CurrenciesData {
  List<CurrencyValue> currencies;

  CurrenciesData({
    required this.currencies,
  });

  factory CurrenciesData.fromJson(Map<String, dynamic> json) => CurrenciesData(
        currencies: List<CurrencyValue>.from(
            json["currencies"].map((x) => CurrencyValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
      };
}

class CurrencyValue {
  String id;
  String image;
  String currency;
  String symbol;
  String abbreviation;
  bool isActive;
  String currencyType;
  DateTime createdAt;

  CurrencyValue({
    required this.id,
    required this.image,
    required this.currency,
    required this.symbol,
    required this.abbreviation,
    required this.isActive,
    required this.currencyType,
    required this.createdAt,
  });

  factory CurrencyValue.fromJson(Map<String, dynamic> json) => CurrencyValue(
        id: json["id"],
        image: json["image"],
        currency: json["currency"],
        symbol: json["symbol"],
        abbreviation: json["abbreviation"],
        isActive: json["isActive"],
        currencyType: json["currencyType"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "currency": currency,
        "symbol": symbol,
        "abbreviation": abbreviation,
        "isActive": isActive,
        "currencyType": currencyType,
        "createdAt": createdAt.toIso8601String(),
      };
}
