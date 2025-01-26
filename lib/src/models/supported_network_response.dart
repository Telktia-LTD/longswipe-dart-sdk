import 'dart:convert';

SupportedCryptoNetworks supportedCryptoNetworksFromJson(String str) =>
    SupportedCryptoNetworks.fromJson(json.decode(str));

String supportedCryptoNetworksToJson(SupportedCryptoNetworks data) =>
    json.encode(data.toJson());

class SupportedCryptoNetworks {
  int code;
  List<Datum> data;
  String message;
  String status;

  SupportedCryptoNetworks({
    required this.code,
    required this.data,
    required this.message,
    required this.status,
  });

  factory SupportedCryptoNetworks.fromJson(Map<String, dynamic> json) =>
      SupportedCryptoNetworks(
        code: json["code"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class Datum {
  String blockExplorerUrl;
  String chainId;
  List<Cryptocurrency> cryptocurrencies;
  String id;
  String networkName;
  String networkType;
  String rpcUrl;

  Datum({
    required this.blockExplorerUrl,
    required this.chainId,
    required this.cryptocurrencies,
    required this.id,
    required this.networkName,
    required this.networkType,
    required this.rpcUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        blockExplorerUrl: json["blockExplorerUrl"],
        chainId: json["chainID"],
        cryptocurrencies: List<Cryptocurrency>.from(
            json["cryptocurrencies"].map((x) => Cryptocurrency.fromJson(x))),
        id: json["id"],
        networkName: json["networkName"],
        networkType: json["networkType"],
        rpcUrl: json["rpcUrl"],
      );

  Map<String, dynamic> toJson() => {
        "blockExplorerUrl": blockExplorerUrl,
        "chainID": chainId,
        "cryptocurrencies":
            List<dynamic>.from(cryptocurrencies.map((x) => x.toJson())),
        "id": id,
        "networkName": networkName,
        "networkType": networkType,
        "rpcUrl": rpcUrl,
      };
}

class Cryptocurrency {
  String currencyAddress;
  CurrencyData currencyData;
  String currencyDecimals;
  String currencyName;
  String id;
  String longswipeContractAddress;
  String networkId;
  bool status;

  Cryptocurrency({
    required this.currencyAddress,
    required this.currencyData,
    required this.currencyDecimals,
    required this.currencyName,
    required this.id,
    required this.longswipeContractAddress,
    required this.networkId,
    required this.status,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) => Cryptocurrency(
        currencyAddress: json["currencyAddress"],
        currencyData: CurrencyData.fromJson(json["currencyData"]),
        currencyDecimals: json["currencyDecimals"],
        currencyName: json["currencyName"],
        id: json["id"],
        longswipeContractAddress: json["longswipeContractAddress"],
        networkId: json["networkID"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "currencyAddress": currencyAddress,
        "currencyData": currencyData.toJson(),
        "currencyDecimals": currencyDecimals,
        "currencyName": currencyName,
        "id": id,
        "longswipeContractAddress": longswipeContractAddress,
        "networkID": networkId,
        "status": status,
      };
}

class CurrencyData {
  String abbrev;
  String currencyType;
  String id;
  String image;
  bool isActive;
  String name;
  String symbol;

  CurrencyData({
    required this.abbrev,
    required this.currencyType,
    required this.id,
    required this.image,
    required this.isActive,
    required this.name,
    required this.symbol,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) => CurrencyData(
        abbrev: json["abbrev"],
        currencyType: json["currencyType"],
        id: json["id"],
        image: json["image"],
        isActive: json["isActive"],
        name: json["name"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "abbrev": abbrev,
        "currencyType": currencyType,
        "id": id,
        "image": image,
        "isActive": isActive,
        "name": name,
        "symbol": symbol,
      };
}
