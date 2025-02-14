enum CurrencyType {
  NGN,
  USD,
  EUR,
  GBP,
  USDC,
  USDT,
}

extension CurrencyTypeExtension on CurrencyType {
  String get value {
    switch (this) {
      case CurrencyType.NGN:
        return "NGN";
      case CurrencyType.USD:
        return "USD";
      case CurrencyType.EUR:
        return "EUR";
      case CurrencyType.GBP:
        return "GBP";
      case CurrencyType.USDC:
        return "USDC";
      case CurrencyType.USDT:
        return "USDT";
    }
  }
}
