import 'dart:convert';
import './voucher_response.dart';

VoucherRedemptionCharges voucherRedemptionChargesFromJson(String str) =>
    VoucherRedemptionCharges.fromJson(json.decode(str));

String voucherRedemptionChargesToJson(VoucherRedemptionCharges data) =>
    json.encode(data.toJson());

class VoucherRedemptionCharges {
  String message;
  String status;
  int code;
  RedemptionData data;

  VoucherRedemptionCharges({
    required this.message,
    required this.status,
    required this.code,
    required this.data,
  });

  factory VoucherRedemptionCharges.fromJson(Map<String, dynamic> json) =>
      VoucherRedemptionCharges(
        message: json["message"],
        status: json["status"],
        code: json["code"],
        data: RedemptionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "code": code,
        "data": data.toJson(),
      };
}

class RedemptionData {
  Charges charges;
  Voucher voucher;

  RedemptionData({
    required this.charges,
    required this.voucher,
  });

  factory RedemptionData.fromJson(Map<String, dynamic> json) => RedemptionData(
        charges: Charges.fromJson(json["charges"]),
        voucher: Voucher.fromJson(json["voucher"]),
      );

  Map<String, dynamic> toJson() => {
        "charges": charges.toJson(),
        "voucher": voucher.toJson(),
      };
}

class Charges {
  dynamic amount;
  dynamic amountInWei;
  dynamic balanceAfterCharges;
  dynamic balanceAfterChargesInWei;
  dynamic gasLimitInWei;
  dynamic gasPriceInWei;
  dynamic processingFee;
  dynamic processingFeeInWei;
  dynamic totalGasCost;
  dynamic totalGasCostAndProcessingFee;
  dynamic totalGasCostAndProcessingFeeInWei;
  dynamic totalGasCostInWei;

  Charges({
    required this.amount,
    required this.amountInWei,
    required this.balanceAfterCharges,
    required this.balanceAfterChargesInWei,
    required this.gasLimitInWei,
    required this.gasPriceInWei,
    required this.processingFee,
    required this.processingFeeInWei,
    required this.totalGasCost,
    required this.totalGasCostAndProcessingFee,
    required this.totalGasCostAndProcessingFeeInWei,
    required this.totalGasCostInWei,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        amount: json["amount"],
        amountInWei: json["amountInWei"],
        balanceAfterCharges: json["balanceAfterCharges"],
        balanceAfterChargesInWei: json["balanceAfterChargesInWei"],
        gasLimitInWei: json["gasLimitInWei"],
        gasPriceInWei: json["gasPriceInWei"],
        processingFee: json["processingFee"],
        processingFeeInWei: json["processingFeeInWei"],
        totalGasCost: json["totalGasCost"],
        totalGasCostAndProcessingFee: json["totalGasCostAndProcessingFee"],
        totalGasCostAndProcessingFeeInWei:
            json["totalGasCostAndProcessingFeeInWei"],
        totalGasCostInWei: json["totalGasCostInWei"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "amountInWei": amountInWei,
        "balanceAfterCharges": balanceAfterCharges,
        "balanceAfterChargesInWei": balanceAfterChargesInWei,
        "gasLimitInWei": gasLimitInWei,
        "gasPriceInWei": gasPriceInWei,
        "processingFee": processingFee,
        "processingFeeInWei": processingFeeInWei,
        "totalGasCost": totalGasCost,
        "totalGasCostAndProcessingFee": totalGasCostAndProcessingFee,
        "totalGasCostAndProcessingFeeInWei": totalGasCostAndProcessingFeeInWei,
        "totalGasCostInWei": totalGasCostInWei,
      };
}

class Voucher {
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

  Voucher({
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

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
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
