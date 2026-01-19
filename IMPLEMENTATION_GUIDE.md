# Floor Bot Mobile - UK Currency & Calculator Implementation

## Overview

This implementation addresses the client requirements for UK currency support and enhanced flooring calculator logic in the Flutter mobile app.

## 🇬🇧 Currency Implementation

### 1. Default UK Currency

- **Base Currency**: GBP (British Pound £) is set as the default
- **Currency Controller**: Manages currency selection and formatting
- **Automatic Conversion**: Displays prices in selected currency with exchange rates

### 2. Files Updated for Currency Support

#### Core Currency Files

- `lib/app/core/constants/currency_constants.dart` - Currency constants and conversion logic
- `lib/app/controllers/currency_controller.dart` - Currency management controller
- `lib/app/views/widgets/settings/currency_settings_widget.dart` - Currency selection UI

#### Updated Controllers

- `lib/app/controllers/product_details_controller.dart` - Product price formatting
- `lib/app/controllers/explore_controller.dart` - Product list price formatting
- `lib/app/controllers/search_controller.dart` - Search results price formatting
- `lib/app/controllers/ai_products_controller.dart` - AI products price formatting

#### Updated Views

- All product display screens now use `formatProductPrice()` method
- Currency symbol automatically updates throughout the app
- Settings screen for currency selection

### 3. Currency Features

```dart
// Default currency (GBP)
static const String defaultCurrency = 'GBP';
static const String defaultCurrencySymbol = '£';

// Supported currencies
- GBP (£) - British Pound (Default)
- USD ($) - US Dollar  
- EUR (€) - Euro

// Automatic price formatting
String formatPrice(double priceInGBP) => '£39.00'
```

## 🧮 Enhanced Flooring Calculator

### 1. Product Types Supported

#### Box-Based Products (Tiles/Packs)

```dart
ProductCalculatorConfig.boxBased(
  coveragePerBox: 16.0, // Square meters per box
  wastePercentage: 5.0,  // Default 5% waste
)
```

**Calculation Logic:**

1. User enters room length × width
2. Calculate total area
3. Add 5% waste: `area × 1.05`
4. Divide by coverage per box
5. Round up to next full box
6. Display: "You need 7 boxes"

#### Sheet-Based Products

**Carpet (Fixed widths: 4m or 5m)**

```dart
ProductCalculatorConfig.carpet()
```

**Vinyl (Fixed widths: 2m, 3m, or 4m)**

```dart
ProductCalculatorConfig.vinyl()
```

**Sheet Calculation Logic:**

1. User enters room length only
2. User selects from available widths (dropdown/radio)
3. Calculate: `length × selected_width`
4. Add 5% waste
5. Display: "You need 4.5m length × 4m width"

### 2. Calculator Components

#### Enhanced Calculator Widget

- `lib/app/views/widgets/product_details/enhanced_floor_calculator_widget.dart`
- Handles all product types dynamically
- Shows/hides width input based on product type
- Displays calculation explanations

#### Product Configuration

- `lib/app/models/product_calculator_config.dart`
- Defines calculator behavior per product
- Supports enable/disable per product

### 3. Calculator Features

#### Box-Based Example

```
Room: 12m²
Waste (5%): 12.6m²
Coverage per box: 2m²
Result: 7 boxes needed
```

#### Sheet-Based Example

```
Length: 4.5m
Selected width: 4m (from dropdown)
Result: 4.5m length × 4m width
Total area: 18.9m² (including 5% waste)
```

## 📱 UI/UX Improvements

### 1. Calculator Interface

- **Visual indicators** for calculation steps
- **Explanation boxes** showing how calculation works
- **Results highlighting** with colored containers
- **Unit conversion** support (sqm ⟷ sqft)

### 2. Currency Settings

- **Dedicated settings widget** for currency selection
- **Real-time updates** throughout the app
- **Visual indicators** for default currency (GBP)
- **Exchange rate disclaimers**

### 3. Product Type Indicators

- Different calculator UI based on product type
- Width selection for sheet products
- Coverage information display
- Waste calculation transparency

## 🔧 Implementation Details

### 1. Admin Configuration (Future)

The system is prepared for admin-side calculator configuration:

```dart
// Enable/disable calculator per product
calculatorConfig: ProductCalculatorConfig.disabled()

// Box-based with custom coverage
calculatorConfig: ProductCalculatorConfig.boxBased(
  coveragePerBox: 20.0,
  wastePercentage: 10.0, // Custom waste percentage
)
```

### 2. Product Examples

#### Updated Product Definitions

```dart
Product(
  name: 'Parquet',
  price: 39.00, // Always in GBP
  calculatorConfig: ProductCalculatorConfig.boxBased(
    coveragePerBox: 16.0, // 4x4m coverage
  ),
)

Product(
  name: 'Premium Carpet',
  price: 35.99,
  calculatorConfig: ProductCalculatorConfig.carpet(),
)
```

### 3. Currency Conversion

```dart
// All prices stored in GBP
// Converted for display only
final convertedPrice = CurrencyConstants.convertFromGBP(priceInGBP, 'USD');
final formattedPrice = CurrencyConstants.formatPrice(convertedPrice, currency: 'USD');
```

## 🎯 Key Benefits

### For UK Clients

- ✅ Default GBP currency
- ✅ Familiar £ symbol throughout app
- ✅ Optional currency switching

### For Calculator Users

- ✅ Accurate box calculations with waste
- ✅ Proper sheet-based calculations
- ✅ Clear calculation explanations
- ✅ Fixed width constraints for sheets
- ✅ Visual calculation steps

### For Administrators

- ✅ Configurable calculator per product
- ✅ Enable/disable calculator option
- ✅ Customizable waste percentages
- ✅ Product type categorization

## 🚀 Usage Examples

### Accessing Currency Settings

```dart
// Navigate to settings
Get.to(() => SettingsScreen());

// Change currency programmatically
Get.find<CurrencyController>().changeCurrency('GBP');
```

### Testing Calculator

1. Open any product with calculator enabled
2. Expand "Floor calculator" section
3. For box-based: Enter length and width
4. For sheet-based: Enter length, select width
5. See real-time calculation results

## 📋 Testing Checklist

### Currency Tests

- [ ] Default currency is GBP (£)
- [ ] Prices display with £ symbol
- [ ] Currency switching works
- [ ] All product screens show correct currency
- [ ] Settings screen currency selection works

### Calculator Tests

- [ ] Box-based products calculate correctly
- [ ] Sheet-based products show width selection
- [ ] 5% waste is added to calculations
- [ ] Results round up to full boxes
- [ ] Calculation explanations are visible
- [ ] Unit conversion (m² ⟷ ft²) works

This implementation fully addresses the client requirements for UK currency default and sophisticated flooring calculator logic with proper waste calculations and product type differentiation.
