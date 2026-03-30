import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stripe_payment/Ui/views/home/home_view.dart';
import 'package:stripe_payment/services/stripe_services.dart';

@StackedApp(
  routes: [MaterialRoute(page: MyHomeScreen)],
  dependencies: [
      LazySingleton(classType: StripeService),
    LazySingleton(classType: NavigationService),
  ],
)

class App {}
