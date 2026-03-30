// lib/services/stripe_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StripeService {


    static final String _publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static final String _secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  // Call this once in main.dart
  static void init() {
    Stripe.publishableKey = _publishableKey;
    Stripe.instance.applySettings();
  }
  Future<String?> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['client_secret']; //
      } else {
        debugPrint('Stripe error: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('createPaymentIntent error: $e');
      return null;
    }
  }

  /// Initialize the payment sheet
  Future<void> initPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Your App Name',
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Colors.blue,
            background: Colors.white,
          ),
          shapes: PaymentSheetShape(
            borderRadius: 8.0,
            borderWidth: 0.5,
          ),
          primaryButton: PaymentSheetPrimaryButtonAppearance(
            colors: PaymentSheetPrimaryButtonTheme(
              light: PaymentSheetPrimaryButtonThemeColors(
                background: Colors.blue,
                text: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } on StripeException catch (e) {
      debugPrint('StripeException: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('presentPaymentSheet error: $e');
      return false;
    }
  }

  Future<bool> processPayment({
    required int amount,
    required String currency,
  }) async {
    final clientSecret = await createPaymentIntent(
      amount: amount,
      currency: currency,
    );

    if (clientSecret == null) return false;

    await initPaymentSheet(clientSecret);
    return await presentPaymentSheet();
  }
}