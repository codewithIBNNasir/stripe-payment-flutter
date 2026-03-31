// lib/UI/views/home/home_view_model.dart

import 'package:stacked/stacked.dart';
import 'package:stripe_payment/app/app.locator.dart';
import 'package:stripe_payment/services/stripe_services.dart';

class PaymentViewModel extends BaseViewModel {
  final _stripeService = locator<StripeService>();

  bool _paymentSuccess = false;
  bool get paymentSuccess => _paymentSuccess;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void resetState() {
    _paymentSuccess = false;
    _errorMessage   = '';
    notifyListeners();
  }

  /// [amount]   in cents — e.g. 2000 = $20.00 / ₨2000
  /// [currency] lowercase ISO code — e.g. 'usd', 'pkr'
  Future<void> processPayment({
    required int    amount,
    required String currency,
  }) async {
    if (amount <= 0) {
      _errorMessage = 'Please enter a valid amount.';
      notifyListeners();
      return;
    }

    setBusy(true);
    _errorMessage   = '';
    _paymentSuccess = false;
    notifyListeners();

    try {
      final clientSecret = await _stripeService.createPaymentIntent(
        amount:   amount,
        currency: currency,
      );

      if (clientSecret == null) {
        _errorMessage = 'Failed to create payment intent. Please try again.';
        notifyListeners();
        return;
      }

      await _stripeService.initPaymentSheet(clientSecret);
      final success = await _stripeService.presentPaymentSheet();

      _paymentSuccess = success;
      _errorMessage   = success ? '' : 'Payment was cancelled or failed.';
      notifyListeners();

    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    } finally {
      setBusy(false);
    }
  }
}