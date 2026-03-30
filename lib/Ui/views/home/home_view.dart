// lib/views/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stripe_payment/Ui/views/home/home_view_model.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
      viewModelBuilder: () => PaymentViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stripe Payment',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error message
            if (model.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  model.errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            // Success message
            if (model.paymentSuccess)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '✅ Payment Successful!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),

            // Pay button
            InkWell(
              onTap: model.isBusy
                  ? null
                  : () => model.processPayment(
                        amount: 2000, // $20.00
                        currency: 'usd',
                      ),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  color: model.isBusy ? Colors.grey : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: model.isBusy
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Pay',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}