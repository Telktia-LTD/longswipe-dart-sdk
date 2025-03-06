// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_charges_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoucherChargesDetailsResponse _$VoucherChargesDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    VoucherChargesDetailsResponse(
      code: (json['code'] as num).toInt(),
      data: json['data'] == null
          ? null
          : VoucherDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$VoucherChargesDetailsResponseToJson(
        VoucherChargesDetailsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

VoucherDetailsData _$VoucherDetailsDataFromJson(Map<String, dynamic> json) =>
    VoucherDetailsData(
      charges: Charges.fromJson(json['charges'] as Map<String, dynamic>),
      voucher: Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoucherDetailsDataToJson(VoucherDetailsData instance) =>
    <String, dynamic>{
      'charges': instance.charges,
      'voucher': instance.voucher,
    };

Charges _$ChargesFromJson(Map<String, dynamic> json) => Charges(
      exchangeRate: (json['exchangeRate'] as num).toInt(),
      fromCurrency:
          Currency.fromJson(json['fromCurrency'] as Map<String, dynamic>),
      isPercentageCharge: json['isPercentageCharge'] as bool,
      percentageCharge: (json['percentageCharge'] as num).toInt(),
      processingFee: (json['processingFee'] as num).toInt(),
      swapAmount: (json['swapAmount'] as num).toInt(),
      toAmount: (json['toAmount'] as num).toInt(),
      toCurrency: Currency.fromJson(json['toCurrency'] as Map<String, dynamic>),
      totalGasAndProceesingFeeInFromCurrency:
          (json['totalGasAndProceesingFeeInFromCurrency'] as num).toInt(),
      totalGasCostAndProcessingFeeInWei:
          (json['totalGasCostAndProcessingFeeInWei'] as num).toInt(),
    );

Map<String, dynamic> _$ChargesToJson(Charges instance) => <String, dynamic>{
      'exchangeRate': instance.exchangeRate,
      'fromCurrency': instance.fromCurrency,
      'isPercentageCharge': instance.isPercentageCharge,
      'percentageCharge': instance.percentageCharge,
      'processingFee': instance.processingFee,
      'swapAmount': instance.swapAmount,
      'toAmount': instance.toAmount,
      'toCurrency': instance.toCurrency,
      'totalGasAndProceesingFeeInFromCurrency':
          instance.totalGasAndProceesingFeeInFromCurrency,
      'totalGasCostAndProcessingFeeInWei':
          instance.totalGasCostAndProcessingFeeInWei,
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      abbrev: json['abbrev'] as String,
      currencyType: json['currencyType'] as String,
      id: json['id'] as String,
      image: json['image'] as String,
      isActive: json['isActive'] as bool,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'abbrev': instance.abbrev,
      'currencyType': instance.currencyType,
      'id': instance.id,
      'image': instance.image,
      'isActive': instance.isActive,
      'name': instance.name,
      'symbol': instance.symbol,
    };

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      amount: (json['amount'] as num?)?.toInt(),
      balance: (json['balance'] as num?)?.toInt(),
      code: json['code'] as String?,
      createdAt: json['createdAt'] as String?,
      createdForExistingUser: json['createdForExistingUser'] as bool?,
      createdForMerchant: json['createdForMerchant'] as bool?,
      createdForNonExistingUser: json['createdForNonExistingUser'] as bool?,
      cryptoVoucherDetails: json['cryptoVoucherDetails'] == null
          ? null
          : CryptoVoucherDetails.fromJson(
              json['cryptoVoucherDetails'] as Map<String, dynamic>),
      generatedCurrency: json['generatedCurrency'] == null
          ? null
          : Currency.fromJson(
              json['generatedCurrency'] as Map<String, dynamic>),
      id: json['id'] as String?,
      isLocked: json['isLocked'] as bool?,
      isUsed: json['isUsed'] as bool?,
      metaData: json['metaData'] as String?,
      onchain: json['onchain'] as bool?,
      onchainProcessing: json['onchainProcessing'] as bool?,
      redeemedVouchers: (json['redeemedVouchers'] as List<dynamic>?)
          ?.map((e) => RedeemedVoucher.fromJson(e as Map<String, dynamic>))
          .toList(),
      transactionHash: json['transactionHash'] as String?,
      wasPaidFor: json['wasPaidFor'] as bool?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'amount': instance.amount,
      'balance': instance.balance,
      'code': instance.code,
      'createdAt': instance.createdAt,
      'createdForExistingUser': instance.createdForExistingUser,
      'createdForMerchant': instance.createdForMerchant,
      'createdForNonExistingUser': instance.createdForNonExistingUser,
      'cryptoVoucherDetails': instance.cryptoVoucherDetails,
      'generatedCurrency': instance.generatedCurrency,
      'id': instance.id,
      'isLocked': instance.isLocked,
      'isUsed': instance.isUsed,
      'metaData': instance.metaData,
      'onchain': instance.onchain,
      'onchainProcessing': instance.onchainProcessing,
      'redeemedVouchers': instance.redeemedVouchers,
      'transactionHash': instance.transactionHash,
      'wasPaidFor': instance.wasPaidFor,
    };

CryptoVoucherDetails _$CryptoVoucherDetailsFromJson(
        Map<String, dynamic> json) =>
    CryptoVoucherDetails(
      balance: json['balance'] as String?,
      codeHash: json['codeHash'] as String?,
      creator: json['creator'] as String?,
      isRedeemed: json['isRedeemed'] as bool?,
      transactionHash: json['transactionHash'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$CryptoVoucherDetailsToJson(
        CryptoVoucherDetails instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'codeHash': instance.codeHash,
      'creator': instance.creator,
      'isRedeemed': instance.isRedeemed,
      'transactionHash': instance.transactionHash,
      'value': instance.value,
    };

RedeemedVoucher _$RedeemedVoucherFromJson(Map<String, dynamic> json) =>
    RedeemedVoucher(
      amount: (json['amount'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      id: json['id'] as String?,
      isMerchant: json['isMerchant'] as bool?,
      redeemedUserId: json['redeemedUserId'] as String?,
      redeemerWalletAddress: json['redeemerWalletAddress'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      voucherId: json['voucherId'] as String?,
    );

Map<String, dynamic> _$RedeemedVoucherToJson(RedeemedVoucher instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'isMerchant': instance.isMerchant,
      'redeemedUserId': instance.redeemedUserId,
      'redeemerWalletAddress': instance.redeemerWalletAddress,
      'user': instance.user,
      'voucherId': instance.voucherId,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      externalId: json['externalId'] as String?,
      id: json['id'] as String?,
      isActive: json['isActive'] as bool?,
      isPinSet: json['isPinSet'] as bool?,
      otherNames: json['otherNames'] as String?,
      phone: json['phone'] as String?,
      regChannel: json['regChannel'] as String?,
      role: json['role'] as String?,
      surname: json['surname'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'externalId': instance.externalId,
      'id': instance.id,
      'isActive': instance.isActive,
      'isPinSet': instance.isPinSet,
      'otherNames': instance.otherNames,
      'phone': instance.phone,
      'regChannel': instance.regChannel,
      'role': instance.role,
      'surname': instance.surname,
      'username': instance.username,
    };
