// lib/viewmodels/payment_viewmodel.dart

import 'package:stacked/stacked.dart';
import 'package:stripe_payment/app/app.locator.dart';
import 'package:stripe_payment/services/stripe_services.dart';

class PaymentViewModel extends BaseViewModel {
  final _stripeService = locator<StripeService>();

  bool _paymentSuccess = false;
  bool get paymentSuccess => _paymentSuccess;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Call this from your View button press
  Future<void> processPayment({
    required int amount,      // in cents e.g. 1000 = $10.00
    required String currency, // e.g. 'usd'
  }) async {
    setBusy(true);
    _errorMessage = '';
    _paymentSuccess = false;
    notifyListeners();

    try {
      
      final clientSecret = await _stripeService.createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      if (clientSecret == null) {
        _errorMessage = 'Failed to create payment intent.';
        notifyListeners();
        return;
      }

     
      await _stripeService.initPaymentSheet(clientSecret);

      
      final success = await _stripeService.presentPaymentSheet();

      _paymentSuccess = success;
      _errorMessage = success ? '' : 'Payment was cancelled or failed.';
      notifyListeners();

    } catch (e) {
      _errorMessage = 'Something went wrong: $e';
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }
}