class CurrencyConstants {
  // Default currency for the UK
  static const String defaultCurrency = 'GBP';
  static const String defaultCurrencySymbol = '£';

  // Currency symbols mapping
  static const Map<String, String> currencySymbols = {
    'GBP': '£',
    'USD': '\$',
    'EUR': '€',
  };

  // Currency names
  static const Map<String, String> currencyNames = {
    'GBP': 'British Pound',
    'USD': 'US Dollar',
    'EUR': 'Euro',
  };

  // Exchange rates (in a real app, this would come from an API)
  static const Map<String, double> exchangeRates = {
    'GBP': 1.0, // Base currency
    'USD': 1.27, // 1 GBP = 1.27 USD (approximate)
    'EUR': 1.20, // 1 GBP = 1.20 EUR (approximate)
  };

  // Get currency symbol for a given currency code
  static String getCurrencySymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? defaultCurrencySymbol;
  }

  // Get currency name for a given currency code
  static String getCurrencyName(String currencyCode) {
    return currencyNames[currencyCode] ?? currencyNames[defaultCurrency]!;
  }

  // Convert price from GBP to another currency
  static double convertFromGBP(double priceInGBP, String toCurrency) {
    final rate = exchangeRates[toCurrency] ?? 1.0;
    return priceInGBP * rate;
  }

  // Convert price to GBP from another currency
  static double convertToGBP(double price, String fromCurrency) {
    final rate = exchangeRates[fromCurrency] ?? 1.0;
    return price / rate;
  }

  // Format price with currency symbol
  static String formatPrice(double price, {String? currency}) {
    final currencyCode = currency ?? defaultCurrency;
    final symbol = getCurrencySymbol(currencyCode);
    return '$symbol${price.toStringAsFixed(2)}';
  }
}
