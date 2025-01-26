<p align="center">                    
<a href="https://img.shields.io/badge/License-MIT-green"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>  
</p>

- [Introduction](#introduction)
  - [Why use the Longswipe SDK](#benefits)
- [Features](#features)
  - [Vouchers](#vouchers)
    - [Redeem voucher](#redeem-voucher)
    - [Verify Voucher](#verify-voucher)
    - [Fetch Redemption charges](#fetch-redemption-charges)
  - [Invoices](#invoices)
    - [Generate invoice](#generate-invoice)

## Introduction

The longswipe flutter SDK is designed to allows merchants integrate a smooth checkout flow for the longswipe ecosystem.

The longswipe package allows you to receieve vouchers as a form of payment or checkout for your good and services, utilising Crypto stable assets ike USDT and USDC across several blockchain network.

## Features

Here are some features of the longswipe SDK

## Vouchers

#### Redeem voucherx

`Redeem Voucher` : Enables you to accept payment from users

```dart
import 'package:longswipe/longswipe.dart';
Future<SuccessResponse> redeemVoucher(
    String voucherCode,
    double amount,
  ) async {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      // var baseUrl = Constants.sandboxBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      // Using the public API key
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);
      var response =
          await client.redeemVoucher(voucher: voucherCode, amount: amount);
      print(response);
      return response;
    } catch (error) {
      print(error);
      throw Exception('Failed to redeem voucher');
    }
  }
```

First screen can be used to just verify the details of a voucher

the second and last screens can be used for the entire checkout flow

<div style={{marginBottom:'10px', display: 'flex', gap: '10px', alignItems: 'center' }}>
  <img src="https://res.cloudinary.com/dm9s6bfd1/image/upload/w_400/v1737881566/longswipe/withOutLockPin_dbcxej.png" alt="Without Lock Pin" style={{ maxWidth: '45%' }} />
  <img src="https://res.cloudinary.com/dm9s6bfd1/image/upload/w_400/v1737881566/longswipe/withlockPin_hvsknm.png" alt="With Lock Pin" style={{ maxWidth: '45%' }} />
</div>

<div style={{marginBottom:'10px', display: 'flex', gap: '10px', alignItems: 'center' }}>
  <img src="https://res.cloudinary.com/dm9s6bfd1/image/upload/v1737914455/longswipe/payconfirmation_qwyiey.png" alt="Without Lock Pin" style={{ maxWidth: '45%' }} />
</div>

`Redeem using the UI form`: Enables you to utilise the UI

```dart
import 'package:longswipe/longswipe.dart';
PayWithLongswipe(
              buttonColor: Colors.deepPurple,
              showLockpin:
                  false, // Show the lockpin field for the user if the voucher requires it
              onLongswipeSubmit: (code) async {
                var amount =
                    100.0; // You can prefill this amount based on the value you want to charge
                await redeemVoucher(code, amount);
              },
            ),

```

`Simple flow`: Can be used to verify the status of a voucher

```dart
import 'package:longswipe/longswipe.dart';
DynamicCheckoutForm(
              onVoucherSubmit: (voucherCode) async {
                // An example to verify the voucher code
                // This can be useful to check if the voucher is valid
                // before proceeding with the payment
                // Or to show them a preview of the voucher details
                // And possibly a section to enter the lockpin if required
                await verifyVoucher(voucherCode);
              },
)
```

You have two options: After verifying the status of a voucher, to show the `showLockpin` to true or false, if the data returned indicates that the voucher is locked.

#### Verify voucher

You can use this verify the status of a voucher

```dart
import 'package:longswipe/longswipe.dart';
Future<VoucherResponse> verifyVoucher(String code) async {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      // var baseUrl = Constants.sandboxBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      // Using the public API key
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);
      var response = await client.verifyVoucher(voucherCode: code);
      print(response);
      return response;
    } catch (error) {
      print(error);
      throw Exception('Failed to verify voucher');
    }
}
```

#### Fetch redemption charges

You can use this to fetch details of any charges that are likely to occur

```dart
Future<VoucherRedemptionCharges> fetchRedemptionCharges() {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);

      // You can pass query parameters to the endpoint
      var queryParameters = {
        'page': 2,
        'limit': 10,
        'search': 'email|name', // Optional search query
      };

      var response = client.getRedemptionCharges(
        voucher: 'VOUCHER_CODE',
        queryParameters: queryParameters,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch redemption charges');
    }
  }

```

## Invoices

#### Generate Invoice

You can use this to accept invoices form your users you want require a payout from you

```dart


```

#### Fetch Invoices, you can use this to fetch invoices generated by your customers

You can use search filter in query params to get a specific users invoices

```dart
 Future<Invoices> fetchInvoices(
    String voucherCode,
    double amount,
  ) {
    try {
      // Using the production base Url
      var baseUrl = Constants.productionBaseUrl;
      var apiKey = "YOUR PUBLIC API KEY";
      var client = LongSwipeClient(baseUrl: baseUrl, apiKey: apiKey);

      // You can pass query parameters to the endpoint
      var queryParameters = {
        'page': 2,
        'limit': 10,
        'search': 'email|name', // Optional search query
      };

      var response = client.fetchInvoices(queryParameters: queryParameters);

      return response;
    } catch (e) {
      throw Exception('Failed to fetch redemption charges');
    }
  }
```
