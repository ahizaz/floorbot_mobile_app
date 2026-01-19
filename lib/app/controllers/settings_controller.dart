import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/constants/currency_constants.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final currencyController = Get.find<CurrencyController>();

  void changeCurrency(String newCurrency) {
    currencyController.changeCurrency(newCurrency);

    Get.snackbar(
      'Currency Changed',
      'Currency changed to ${CurrencyConstants.getCurrencyName(newCurrency)}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  List<String> get availableCurrencies =>
      currencyController.availableCurrencies;

  String get currentCurrency => currencyController.currentCurrency.value;

  String getCurrencyDisplayName(String currency) {
    final symbol = CurrencyConstants.getCurrencySymbol(currency);
    final name = CurrencyConstants.getCurrencyName(currency);
    return '$name ($symbol)';
  }
}
