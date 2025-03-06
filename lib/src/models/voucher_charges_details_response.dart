import 'package:json_annotation/json_annotation.dart';

part 'voucher_charges_details_response.g.dart';

@JsonSerializable()
class VoucherChargesDetailsResponse {
  final int code;
  final VoucherDetailsData? data;
  final String message;
  final String status;

  VoucherChargesDetailsResponse({
    required this.code,
    this.data,
    required this.message,
    required this.status,
  });

  factory VoucherChargesDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$VoucherChargesDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherChargesDetailsResponseToJson(this);
}

@JsonSerializable()
class VoucherDetailsData {
  final Charges charges;
  final Voucher voucher;

  VoucherDetailsData({
    required this.charges,
    required this.voucher,
  });

  factory VoucherDetailsData.fromJson(Map<String, dynamic> json) =>
      _$VoucherDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDetailsDataToJson(this);
}

@JsonSerializable()
class Charges {
  final int exchangeRate;
  final Currency fromCurrency;
  final bool isPercentageCharge;
  final int percentageCharge;
  final int processingFee;
  final int swapAmount;
  final int toAmount;
  final Currency toCurrency;
  final int totalGasAndProceesingFeeInFromCurrency;
  final int totalGasCostAndProcessingFeeInWei;

  Charges({
    required this.exchangeRate,
    required this.fromCurrency,
    required this.isPercentageCharge,
    required this.percentageCharge,
    required this.processingFee,
    required this.swapAmount,
    required this.toAmount,
    required this.toCurrency,
    required this.totalGasAndProceesingFeeInFromCurrency,
    required this.totalGasCostAndProcessingFeeInWei,
  });

  factory Charges.fromJson(Map<String, dynamic> json) =>
      _$ChargesFromJson(json);

  Map<String, dynamic> toJson() => _$ChargesToJson(this);
}

@JsonSerializable()
class Currency {
  final String abbrev;
  final String currencyType;
  final String id;
  final String image;
  final bool isActive;
  final String name;
  final String symbol;

  Currency({
    required this.abbrev,
    required this.currencyType,
    required this.id,
    required this.image,
    required this.isActive,
    required this.name,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable()
class Voucher {
  final int? amount;
  final int? balance;
  final String? code;
  final String? createdAt;
  final bool? createdForExistingUser;
  final bool? createdForMerchant;
  final bool? createdForNonExistingUser;
  final CryptoVoucherDetails? cryptoVoucherDetails;
  final Currency? generatedCurrency;
  final String? id;
  final bool? isLocked;
  final bool? isUsed;
  final String? metaData;
  final bool? onchain;
  final bool? onchainProcessing;
  final List<RedeemedVoucher>? redeemedVouchers;
  final String? transactionHash;
  final bool? wasPaidFor;

  Voucher({
    this.amount,
    this.balance,
    this.code,
    this.createdAt,
    this.createdForExistingUser,
    this.createdForMerchant,
    this.createdForNonExistingUser,
    this.cryptoVoucherDetails,
    this.generatedCurrency,
    this.id,
    this.isLocked,
    this.isUsed,
    this.metaData,
    this.onchain,
    this.onchainProcessing,
    this.redeemedVouchers,
    this.transactionHash,
    this.wasPaidFor,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}

@JsonSerializable()
class CryptoVoucherDetails {
  final String? balance;
  final String? codeHash;
  final String? creator;
  final bool? isRedeemed;
  final String? transactionHash;
  final String? value;

  CryptoVoucherDetails({
    this.balance,
    this.codeHash,
    this.creator,
    this.isRedeemed,
    this.transactionHash,
    this.value,
  });

  factory CryptoVoucherDetails.fromJson(Map<String, dynamic> json) =>
      _$CryptoVoucherDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoVoucherDetailsToJson(this);
}

@JsonSerializable()
class RedeemedVoucher {
  final int? amount;
  final String? createdAt;
  final String? id;
  final bool? isMerchant;
  final String? redeemedUserId;
  final String? redeemerWalletAddress;
  final User? user;
  final String? voucherId;

  RedeemedVoucher({
    this.amount,
    this.createdAt,
    this.id,
    this.isMerchant,
    this.redeemedUserId,
    this.redeemerWalletAddress,
    this.user,
    this.voucherId,
  });

  factory RedeemedVoucher.fromJson(Map<String, dynamic> json) =>
      _$RedeemedVoucherFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemedVoucherToJson(this);
}

@JsonSerializable()
class User {
  final String? avatar;
  final String? email;
  final bool? emailVerified;
  final String? externalId;
  final String? id;
  final bool? isActive;
  final bool? isPinSet;
  final String? otherNames;
  final String? phone;
  final String? regChannel;
  final String? role;
  final String? surname;
  final String? username;

  User({
    this.avatar,
    this.email,
    this.emailVerified,
    this.externalId,
    this.id,
    this.isActive,
    this.isPinSet,
    this.otherNames,
    this.phone,
    this.regChannel,
    this.role,
    this.surname,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
