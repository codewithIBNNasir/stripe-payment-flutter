import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stripe_payment/app/app.locator.dart';
import 'package:stripe_payment/app/app.router.dart';
import 'package:stripe_payment/services/stripe_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Load .env file first
  await dotenv.load(fileName: ".env");
  
  // ✅ Publishable key now comes from .env (not hardcoded)
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  
  await setupLocator();
  StripeService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.myHomeScreen,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
