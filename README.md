<p align="center">                    
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>  
</p>

- [Introduction](#introduction)
  - [Why use the Longswipe SDK](#benefits)
- [Features](#features)
  - [Vouchers](#vouchers)
    - [Verify Voucher](#verify-voucher)
    - [Redeem voucher](#redeem-voucher)
    - [Fetch Redemption charges](#fetch-redemption-charges)
    - [API Response](#api-response)

## Introduction

The longswipe flutter SDK is designed to allows merchants integrate a smooth checkout flow for the longswipe ecosystem.

The longswipe package allows you to receieve vouchers as a form of payment or checkout for your good and services, utilising Crypto stable assets like USDT and USDC across several blockchain network.

## Features

### Supported Currencies

| Enum                    |
| :---------------------- | :--------- |
| CurrencyType.USD.value  | US Dollar  |
| CurrencyType.EUR.value  | Euro       |
| CurrencyType.NGN.value  | Naira      |
| CurrencyType.GBP.value  | Pounds     |
| CurrencyType.USDC.value | USD Coin   |
| CurrencyType.USDT.value | USD Tether |

Here are some features of the longswipe SDK

```dart
import 'package:longswipe_payment/longswipe_payment.dart';

final client = LongswipeClient(
    apiKey: 'your-public-api-key',
    isSandbox: false,
  );
```

### Currency Type Enums

| Enum                    | Currency   |
| :---------------------- | :--------- |
| CurrencyType.USD.value  | US Dollar  |
| CurrencyType.EUR.value  | Euro       |
| CurrencyType.NGN.value  | Naira      |
| CurrencyType.GBP.value  | Pounds     |
| CurrencyType.USDC.value | USD Coin   |
| CurrencyType.USDT.value | USD Tether |

### Properties

| Properties             |                                  |
| :--------------------- | :------------------------------- |
| voucherCode            | Voucher code                     |
| lockPin                | Voucher lock pin (optional)      |
| amount                 | Amount to redeem                 |
| toCurrencyAbbreviation | Currency to redeem to            |
| walletAddress          | Crypto wallet address (optional) |

## Vouchers

#### Fetch voucher information

This will enabke you fetch voucher information and charges

```dart
Future<void> _verifyAndFetchVoucherDetails() async {
    if (_voucherCodeController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final details = await client.fetchVoucherDetails(
        voucherCode: _voucherCodeController.text,
        lockPin: _pinController.text,
        amount: int.parse(_amountController.text),
        toCurrencyAbbreviation: CurrencyType.USDC.value,
        walletAddress: walletAddress,
      );

      if (!mounted) return;

      // Show bottom sheet with voucher details
      showModalBottomSheet(
        context: context,
        builder: (context) => VoucherDetailsSheet(
          details: details,
          onProceed: () {
            Navigator.pop(context);
            _processPayment();
          },
        ),
      );
    } on LongswipeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
```

#### Redeem voucher

This will enabke you redeem voucher

```dart
Future<void> _processPayment() async {
    setState(() => _isLoading = true);

    try {
      final result = await client.processVoucherPayment(
        voucherCode: _voucherCodeController.text,
        lockPin: _pinController.text,
        amount: int.parse(_amountController.text),
        toCurrencyAbbreviation: CurrencyType.USDC.value,
        walletAddress: walletAddress,
      );

      if (!mounted) return;

      if (result.status != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result.message}')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

      // Clear form after successful payment
      _voucherCodeController.clear();
      _pinController.clear();
      _amountController.clear();
    } on LongswipeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
```

#### Using the ui

`Redeem using the UI form`: Enables you to utilise the default UI

```dart
LongswipeCheckoutWidget(
  isSandbox: false,
  publicKey: 'PUBLIC-API-KEY',
  amount: 1000,
  currencyCode: 'CURRENCY TO RECEIVE',
  walletAddress: "CRYPTO-WALLET-ADDRESS (Optional)",
),

```

##### Using custom theme

```dart
LongswipeCheckoutWidget(
  publicKey: 'PUBLIC-API-KEY',
  isSandbox: false,
  amount: 20,
  currencyCode: 'CURRENCY TO RECEIVE',
  walletAddress: "CRYPTO-WALLET-ADDRESS (Optional)",
  theme: LongswipeTheme(
    backgroundColor: Colors.black,
    inputDecoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    lockPinInputDecoration: InputDecoration(
      contentPadding: const EdgeInsets.all(2),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconColor: Colors.white,
    containerShadow: const [],
    titleStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    buttonTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    primaryButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    secondaryButtonStyle: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.purple),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    contentPadding: const EdgeInsets.all(16),
    containerMargin: const EdgeInsets.all(16),
    borderRadius: 8,
    labelStyle: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    cancelButtonTextStyle: const TextStyle(
      color: Colors.purple,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    inputTextStyle: const TextStyle(
      color: Colors.white,
    ),
    dialogContentTextStyle: const TextStyle(
      color: Colors.white,
    ),
  ),
),
```

#### Using custom UI

```dart
LongswipePaymentWidget(
    client: LongswipeClient(
      apiKey: 'your-public-api-key',
      isSandbox: false,
    ),
    receivingCurrencyId: 'currency-id',
    walletAddress: 'wallet-address',
    useBottomSheet: true,
    voucherCodeBuilder: (context, controller) {
      return CustomInput(
        controller: controller,
        label: 'Voucher Code',
        icon: Icons.confirmation_number,
      );
    },
    voucherPinBuilder: (context, controller) {
      return CustomInput(
        controller: controller,
        label: 'Lock PIN (Optional)',
        icon: Icons.lock,
        obscureText: true,
      );
    },
    amountBuilder: (context, controller) {
      return CustomInput(
        controller: controller,
        label: 'Amount',
        icon: Icons.attach_money,
        keyboardType: TextInputType.number,
      );
    },
    submitButtonBuilder: (context, onSubmit) {
      return CustomButton(
        onPressed: onSubmit,
        label: 'Complete Payment',
      );
    },
    loadingWidget: const CustomLoadingIndicator(),
    onSuccessFetchVoucherDetails: (result) {
      log(result.toJson().toString());
    },
    onSuccess: (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
    },
    onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.message}')),
      );
    },
  ),
```

## API Response Models

### Fetch Voucher Details Response

```json
{
  "code": 0,
  "data": {
    "charges": {
      "amount": 0,
      "amountInWei": 0,
      "balanceAfterCharges": 0,
      "balanceAfterChargesInWei": 0,
      "gasLimitInWei": 0,
      "gasPriceInWei": 0,
      "processingFee": 0,
      "processingFeeInWei": 0,
      "totalGasCost": 0,
      "totalGasCostAndProcessingFee": 0,
      "totalGasCostAndProcessingFeeInWei": 0,
      "totalGasCostInWei": 0
    },
    "voucher": {
      "amount": 0,
      "balance": 0,
      "code": "string",
      "createdAt": "string",
      "createdForExistingUser": true,
      "createdForMerchant": true,
      "createdForNonExistingUser": true,
      "cryptoVoucherDetails": {
        "balance": "string",
        "codeHash": "string",
        "creator": "string",
        "isRedeemed": true,
        "transactionHash": "string",
        "value": "string"
      },
      "generatedCurrency": {
        "abbrev": "string",
        "currencyType": "string",
        "id": "string",
        "image": "string",
        "isActive": true,
        "name": "string",
        "symbol": "string"
      }
    }
  },
  "message": "string",
  "status": "string"
}
```

### Process Payment Response

```json
{
  "code": 0,
  "message": "string",
  "status": "string"
}
```
