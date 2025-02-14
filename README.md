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

Here are some features of the longswipe SDK

```dart
import 'package:longswipe_payment/longswipe_payment.dart';

final client = LongswipeClient(
    apiKey: 'your-public-api-key',
    isSandbox: false,
  );
```

## Vouchers

#### Fetch voucher information

This will enabke you fetch voucher information and charges

```dart
Future<void> _verifyVoucher() async {
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
        receivingCurrencyId: receivingCurrencyId,
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
        receivingCurrencyId: receivingCurrencyId,
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
LongswipePaymentWidget(
    client: LongswipeClient(
      apiKey: 'your-public-api-key',
      isSandbox: false,
    ),
    useBottomSheet: true,
    receivingCurrencyId: 'currency-id',
    walletAddress: 'wallet-address',
    onSuccess: (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
    },
    onSuccessFetchVoucherDetails: (result) {
      log(result.toJson().toString());
    },
    onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.message}')),
      );
    },
  )

```

##### Using custom theme

```dart
LongswipePaymentWidget(
    client: LongswipeClient(
      apiKey: 'your-public-api-key',
      isSandbox: false,
    ),
    receivingCurrencyId: 'currency-id',
    walletAddress: 'wallet-address',
    useBottomSheet: true,
    theme: LongswipeTheme(
      paymentButtonStyle: PaymentButtonStyle(
        backgroundColor: Theme.of(context).colorScheme.primary,
        height: 56,
        borderRadius: 28,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputFieldStyle: InputFieldStyle(
        borderRadius: 12,
        textStyle: GoogleFonts.inter(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    onSuccessFetchVoucherDetails: (result) {
      log(result.toJson().toString());
    },
    onSuccess: (result) {
      log(result.toJson().toString());
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
