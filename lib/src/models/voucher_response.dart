// To parse this JSON data, do
//
//     final voucherResponse = voucherResponseFromJson(jsonString);

import 'dart:convert';

VoucherResponse voucherResponseFromJson(String str) =>
    VoucherResponse.fromJson(json.decode(str));

String voucherResponseToJson(VoucherResponse data) =>
    json.encode(data.toJson());

class VoucherResponse {
  String message;
  String status;
  int code;
  Data data;

  VoucherResponse({
    required this.message,
    required this.status,
    required this.code,
    required this.data,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) =>
      VoucherResponse(
        message: json["message"],
        status: json["status"],
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  int amount;
  int balance;
  String code;
  String createdAt;
  bool createdForExistingUser;
  bool createdForMerchant;
  bool createdForNonExistingUser;
  CryptoVoucherDetails cryptoVoucherDetails;
  GeneratedCurrency generatedCurrency;
  String id;
  bool isLocked;
  bool isUsed;
  String metaData;
  bool onchain;
  bool onchainProcessing;
  List<RedeemedVoucher> redeemedVouchers;
  String transactionHash;
  bool wasPaidFor;

  Data({
    required this.amount,
    required this.balance,
    required this.code,
    required this.createdAt,
    required this.createdForExistingUser,
    required this.createdForMerchant,
    required this.createdForNonExistingUser,
    required this.cryptoVoucherDetails,
    required this.generatedCurrency,
    required this.id,
    required this.isLocked,
    required this.isUsed,
    required this.metaData,
    required this.onchain,
    required this.onchainProcessing,
    required this.redeemedVouchers,
    required this.transactionHash,
    required this.wasPaidFor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        amount: json["amount"],
        balance: json["balance"],
        code: json["code"],
        createdAt: json["createdAt"],
        createdForExistingUser: json["createdForExistingUser"],
        createdForMerchant: json["createdForMerchant"],
        createdForNonExistingUser: json["createdForNonExistingUser"],
        cryptoVoucherDetails:
            CryptoVoucherDetails.fromJson(json["cryptoVoucherDetails"]),
        generatedCurrency:
            GeneratedCurrency.fromJson(json["generatedCurrency"]),
        id: json["id"],
        isLocked: json["isLocked"],
        isUsed: json["isUsed"],
        metaData: json["metaData"],
        onchain: json["onchain"],
        onchainProcessing: json["onchainProcessing"],
        redeemedVouchers: List<RedeemedVoucher>.from(
            json["redeemedVouchers"].map((x) => RedeemedVoucher.fromJson(x))),
        transactionHash: json["transactionHash"],
        wasPaidFor: json["wasPaidFor"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "balance": balance,
        "code": code,
        "createdAt": createdAt,
        "createdForExistingUser": createdForExistingUser,
        "createdForMerchant": createdForMerchant,
        "createdForNonExistingUser": createdForNonExistingUser,
        "cryptoVoucherDetails": cryptoVoucherDetails.toJson(),
        "generatedCurrency": generatedCurrency.toJson(),
        "id": id,
        "isLocked": isLocked,
        "isUsed": isUsed,
        "metaData": metaData,
        "onchain": onchain,
        "onchainProcessing": onchainProcessing,
        "redeemedVouchers":
            List<dynamic>.from(redeemedVouchers.map((x) => x.toJson())),
        "transactionHash": transactionHash,
        "wasPaidFor": wasPaidFor,
      };
}

class CryptoVoucherDetails {
  String balance;
  String codeHash;
  String creator;
  bool isRedeemed;
  String transactionHash;
  String value;

  CryptoVoucherDetails({
    required this.balance,
    required this.codeHash,
    required this.creator,
    required this.isRedeemed,
    required this.transactionHash,
    required this.value,
  });

  factory CryptoVoucherDetails.fromJson(Map<String, dynamic> json) =>
      CryptoVoucherDetails(
        balance: json["balance"],
        codeHash: json["codeHash"],
        creator: json["creator"],
        isRedeemed: json["isRedeemed"],
        transactionHash: json["transactionHash"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "codeHash": codeHash,
        "creator": creator,
        "isRedeemed": isRedeemed,
        "transactionHash": transactionHash,
        "value": value,
      };
}

class GeneratedCurrency {
  String abbrev;
  String currencyType;
  String id;
  String image;
  bool isActive;
  String name;
  String symbol;

  GeneratedCurrency({
    required this.abbrev,
    required this.currencyType,
    required this.id,
    required this.image,
    required this.isActive,
    required this.name,
    required this.symbol,
  });

  factory GeneratedCurrency.fromJson(Map<String, dynamic> json) =>
      GeneratedCurrency(
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

class RedeemedVoucher {
  int amount;
  String createdAt;
  String id;
  bool isMerchant;
  String redeemedUserId;
  String redeemerWalletAddress;
  User user;
  String voucherId;

  RedeemedVoucher({
    required this.amount,
    required this.createdAt,
    required this.id,
    required this.isMerchant,
    required this.redeemedUserId,
    required this.redeemerWalletAddress,
    required this.user,
    required this.voucherId,
  });

  factory RedeemedVoucher.fromJson(Map<String, dynamic> json) =>
      RedeemedVoucher(
        amount: json["amount"],
        createdAt: json["createdAt"],
        id: json["id"],
        isMerchant: json["isMerchant"],
        redeemedUserId: json["redeemedUserID"],
        redeemerWalletAddress: json["redeemerWalletAddress"],
        user: User.fromJson(json["user"]),
        voucherId: json["voucherID"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "createdAt": createdAt,
        "id": id,
        "isMerchant": isMerchant,
        "redeemedUserID": redeemedUserId,
        "redeemerWalletAddress": redeemerWalletAddress,
        "user": user.toJson(),
        "voucherID": voucherId,
      };
}

class User {
  String avatar;
  String email;
  bool emailVerified;
  String externalId;
  String id;
  bool isActive;
  bool isPinSet;
  String otherNames;
  String phone;
  String regChannel;
  String role;
  String surname;
  String username;

  User({
    required this.avatar,
    required this.email,
    required this.emailVerified,
    required this.externalId,
    required this.id,
    required this.isActive,
    required this.isPinSet,
    required this.otherNames,
    required this.phone,
    required this.regChannel,
    required this.role,
    required this.surname,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: json["avatar"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        externalId: json["externalID"],
        id: json["id"],
        isActive: json["isActive"],
        isPinSet: json["isPinSet"],
        otherNames: json["otherNames"],
        phone: json["phone"],
        regChannel: json["regChannel"],
        role: json["role"],
        surname: json["surname"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "email": email,
        "emailVerified": emailVerified,
        "externalID": externalId,
        "id": id,
        "isActive": isActive,
        "isPinSet": isPinSet,
        "otherNames": otherNames,
        "phone": phone,
        "regChannel": regChannel,
        "role": role,
        "surname": surname,
        "username": username,
      };
}
