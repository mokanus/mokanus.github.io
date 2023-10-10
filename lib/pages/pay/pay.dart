import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:tingfm/values/payment.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<StatefulWidget> createState() => PayPageState();
}

class PayPageState extends State<PayPage> with WidgetsBindingObserver {
  var applePaybutton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    paymentItems: const [
      PaymentItem(
          amount: '0.01',
          label: "Item A",
          status: PaymentItemStatus.final_price),
      PaymentItem(
          amount: '0.01',
          label: "Item B",
          status: PaymentItemStatus.final_price),
      PaymentItem(
          amount: '0.01',
          label: "Total",
          status: PaymentItemStatus.final_price),
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.buy,
    margin: const EdgeInsets.only(top: 15.0),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
    onPaymentResult: (result) {
      debugPrint('pay result : $result');
    },
  );

  var googlePaybutton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
          amount: '0.01',
          label: "Item A",
          status: PaymentItemStatus.final_price),
      PaymentItem(
          amount: '0.01',
          label: "Item B",
          status: PaymentItemStatus.final_price),
      PaymentItem(
          amount: '0.01',
          label: "Total",
          status: PaymentItemStatus.final_price),
    ],
    width: double.infinity,
    height: 50,
    type: GooglePayButtonType.buy,
    margin: const EdgeInsets.only(top: 15.0),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
    onPaymentResult: (Map<String, dynamic> result) {
      debugPrint('pay result : $result');
    },
  );

  void onSignUserInTap() async {}

  @override
  Widget build(BuildContext context) {
    return Center(child: Platform.isIOS ? applePaybutton : googlePaybutton);
  }
}
