import 'package:json_annotation/json_annotation.dart';

part 'voucher_details_response.g.dart';

@JsonSerializable()
class VoucherDetailsResponse {
  final int code;
  final VoucherDetail? data;
  final String message;
  final String status;

  VoucherDetailsResponse({
    required this.code,
    this.data,
    required this.message,
    required this.status,
  });

  factory VoucherDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$VoucherDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDetailsResponseToJson(this);
}

@JsonSerializable()
class VoucherDetail {
  final int amount;
  final int balance;
  final String code;
  final String createdAt;
  final bool createdForExistingUser;
  final bool createdForMerchant;
  final bool createdForNonExistingUser;
  final CryptoVoucherDetails cryptoVoucherDetails;
  final GeneratedCurrency generatedCurrency;
  final String id;
  final bool isLocked;
  final bool isUsed;
  final String metaData;
  final bool onchain;
  final bool onchainProcessing;
  final List<RedeemedVoucher> redeemedVouchers;
  final String transactionHash;
  final bool wasPaidFor;

  VoucherDetail({
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

  factory VoucherDetail.fromJson(Map<String, dynamic> json) =>
      _$VoucherDetailFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherDetailToJson(this);
}

@JsonSerializable()
class CryptoVoucherDetails {
  final String balance;
  final String codeHash;
  final String creator;
  final bool isRedeemed;
  final String transactionHash;
  final String value;

  CryptoVoucherDetails({
    required this.balance,
    required this.codeHash,
    required this.creator,
    required this.isRedeemed,
    required this.transactionHash,
    required this.value,
  });

  factory CryptoVoucherDetails.fromJson(Map<String, dynamic> json) =>
      _$CryptoVoucherDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoVoucherDetailsToJson(this);
}

@JsonSerializable()
class GeneratedCurrency {
  final String abbrev;
  final String currencyType;
  final String id;
  final String image;
  final bool isActive;
  final String name;
  final String symbol;

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
      _$GeneratedCurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratedCurrencyToJson(this);
}

@JsonSerializable()
class RedeemedVoucher {
  final int amount;
  final String createdAt;
  final String id;
  final bool isMerchant;
  final String redeemedUserId;
  final String redeemerWalletAddress;
  final User user;
  final String voucherId;

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
      _$RedeemedVoucherFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemedVoucherToJson(this);
}

@JsonSerializable()
class User {
  final String avatar;
  final String email;
  final bool emailVerified;
  final String externalId;
  final String id;
  final bool isActive;
  final bool isPinSet;
  final String otherNames;
  final String phone;
  final String regChannel;
  final String role;
  final String surname;
  final String username;

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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
