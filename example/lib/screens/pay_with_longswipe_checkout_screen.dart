import 'package:flutter/material.dart';
import 'package:longswipe_payment/longswipe_payment.dart';

class PayWithLongswipeCheckoutScreen extends StatefulWidget {
  const PayWithLongswipeCheckoutScreen({super.key});

  @override
  State<PayWithLongswipeCheckoutScreen> createState() =>
      _PayWithLongswipeCheckoutScreenState();
}

class _PayWithLongswipeCheckoutScreenState
    extends State<PayWithLongswipeCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay With Longswipe Checkout'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LongswipeCheckoutWidget(
                isSandbox: false,
                publicKey: 'PUBLIC-API-KEY',
                amount: 20,
                currencyCode: CurrencyType.USDC.value,
                walletAddress: "",
              ),
              const SizedBox(height: 16),
              LongswipeCheckoutWidget(
                publicKey: 'PUBLIC-API-KEY',
                isSandbox: false,
                currencyCode: CurrencyType.USDC.value,
                amount: 20,
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
            ],
          ),
        ),
      ),
    );
  }
}
