import 'dart:convert';

Invoices invoicesFromJson(String str) => Invoices.fromJson(json.decode(str));

String invoicesToJson(Invoices data) => json.encode(data.toJson());

class Invoices {
  int code;
  InvoiceData data;
  String message;
  String status;

  Invoices({
    required this.code,
    required this.data,
    required this.message,
    required this.status,
  });

  factory Invoices.fromJson(Map<String, dynamic> json) => Invoices(
        code: json["code"],
        data: InvoiceData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class InvoiceData {
  List<Invoice> invoices;
  int total;

  InvoiceData({
    required this.invoices,
    required this.total,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        invoices: List<Invoice>.from(
            json["invoices"].map((x) => Invoice.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
        "total": total,
      };
}

class Invoice {
  BlockchainNetwork blockchainNetwork;
  String createdAt;
  Currency currency;
  String dueDate;
  String id;
  String invoiceDate;
  List<InvoiceItem> invoiceItems;
  String invoiceNumber;
  MerchantUser merchantUser;
  String status;
  int totalAmount;
  String updatedAt;
  String userId;

  Invoice({
    required this.blockchainNetwork,
    required this.createdAt,
    required this.currency,
    required this.dueDate,
    required this.id,
    required this.invoiceDate,
    required this.invoiceItems,
    required this.invoiceNumber,
    required this.merchantUser,
    required this.status,
    required this.totalAmount,
    required this.updatedAt,
    required this.userId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        blockchainNetwork:
            BlockchainNetwork.fromJson(json["blockchainNetwork"]),
        createdAt: json["createdAt"],
        currency: Currency.fromJson(json["currency"]),
        dueDate: json["dueDate"],
        id: json["id"],
        invoiceDate: json["invoiceDate"],
        invoiceItems: List<InvoiceItem>.from(
            json["invoiceItems"].map((x) => InvoiceItem.fromJson(x))),
        invoiceNumber: json["invoiceNumber"],
        merchantUser: MerchantUser.fromJson(json["merchantUser"]),
        status: json["status"],
        totalAmount: json["totalAmount"],
        updatedAt: json["updatedAt"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "blockchainNetwork": blockchainNetwork.toJson(),
        "createdAt": createdAt,
        "currency": currency.toJson(),
        "dueDate": dueDate,
        "id": id,
        "invoiceDate": invoiceDate,
        "invoiceItems": List<dynamic>.from(invoiceItems.map((x) => x.toJson())),
        "invoiceNumber": invoiceNumber,
        "merchantUser": merchantUser.toJson(),
        "status": status,
        "totalAmount": totalAmount,
        "updatedAt": updatedAt,
        "userId": userId,
      };
}

class BlockchainNetwork {
  String blockExplorerUrl;
  String chainId;
  String id;
  String networkName;

  BlockchainNetwork({
    required this.blockExplorerUrl,
    required this.chainId,
    required this.id,
    required this.networkName,
  });

  factory BlockchainNetwork.fromJson(Map<String, dynamic> json) =>
      BlockchainNetwork(
        blockExplorerUrl: json["blockExplorerUrl"],
        chainId: json["chainID"],
        id: json["id"],
        networkName: json["networkName"],
      );

  Map<String, dynamic> toJson() => {
        "blockExplorerUrl": blockExplorerUrl,
        "chainID": chainId,
        "id": id,
        "networkName": networkName,
      };
}

class Currency {
  String abbrev;
  String currencyType;
  String id;
  String image;
  bool isActive;
  String name;
  String symbol;

  Currency({
    required this.abbrev,
    required this.currencyType,
    required this.id,
    required this.image,
    required this.isActive,
    required this.name,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
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

class InvoiceItem {
  String createdAt;
  String description;
  String id;
  int quantity;
  int totalPrice;
  int unitPrice;
  String updatedAt;

  InvoiceItem({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.quantity,
    required this.totalPrice,
    required this.unitPrice,
    required this.updatedAt,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        createdAt: json["createdAt"],
        description: json["description"],
        id: json["id"],
        quantity: json["quantity"],
        totalPrice: json["totalPrice"],
        unitPrice: json["unitPrice"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "description": description,
        "id": id,
        "quantity": quantity,
        "totalPrice": totalPrice,
        "unitPrice": unitPrice,
        "updatedAt": updatedAt,
      };
}

class MerchantUser {
  String email;
  String id;
  String name;

  MerchantUser({
    required this.email,
    required this.id,
    required this.name,
  });

  factory MerchantUser.fromJson(Map<String, dynamic> json) => MerchantUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
