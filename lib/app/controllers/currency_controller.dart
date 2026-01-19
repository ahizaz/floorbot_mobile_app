import 'package:floor_bot_mobile/app/core/constants/currency_constants.dart';
import 'package:get/get.dart';

class CurrencyController extends GetxController {
  final RxString currentCurrency = CurrencyConstants.defaultCurrency.obs;
  final RxString currentCurrencySymbol =
      CurrencyConstants.defaultCurrencySymbol.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default UK currency
    currentCurrency.value = CurrencyConstants.defaultCurrency;
    currentCurrencySymbol.value = CurrencyConstants.defaultCurrencySymbol;
  }

  void changeCurrency(String newCurrency) {
    if (CurrencyConstants.currencySymbols.containsKey(newCurrency)) {
      currentCurrency.value = newCurrency;
      currentCurrencySymbol.value = CurrencyConstants.getCurrencySymbol(
        newCurrency,
      );
    }
  }

  String formatPrice(double priceInGBP) {
    if (currentCurrency.value == CurrencyConstants.defaultCurrency) {
      return CurrencyConstants.formatPrice(
        priceInGBP,
        currency: currentCurrency.value,
      );
    } else {
      final convertedPrice = CurrencyConstants.convertFromGBP(
        priceInGBP,
        currentCurrency.value,
      );
      return CurrencyConstants.formatPrice(
        convertedPrice,
        currency: currentCurrency.value,
      );
    }
  }

  double getConvertedPrice(double priceInGBP) {
    if (currentCurrency.value == CurrencyConstants.defaultCurrency) {
      return priceInGBP;
    } else {
      return CurrencyConstants.convertFromGBP(
        priceInGBP,
        currentCurrency.value,
      );
    }
  }

  List<String> get availableCurrencies =>
      CurrencyConstants.currencySymbols.keys.toList();

  String get currencyName =>
      CurrencyConstants.getCurrencyName(currentCurrency.value);
}
