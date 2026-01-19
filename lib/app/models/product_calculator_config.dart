enum ProductType {
  boxBased, // Tiles/Packs - calculated in boxes
  carpet, // Carpet - sheet-based with fixed widths (4m or 5m)
  vinyl, // Vinyl - sheet-based with fixed widths (2m, 3m, or 4m)
  simple, // Simple unit products (no calculator needed)
}

enum CalculatorType { enabled, disabled }

enum SheetWidth {
  carpet4m(4.0, 'Carpet 4m'),
  carpet5m(5.0, 'Carpet 5m'),
  vinyl2m(2.0, 'Vinyl 2m'),
  vinyl3m(3.0, 'Vinyl 3m'),
  vinyl4m(4.0, 'Vinyl 4m');

  const SheetWidth(this.width, this.displayName);
  final double width;
  final String displayName;

  static List<SheetWidth> getCarpetWidths() => [carpet4m, carpet5m];
  static List<SheetWidth> getVinylWidths() => [vinyl2m, vinyl3m, vinyl4m];
}

class ProductCalculatorConfig {
  final ProductType productType;
  final CalculatorType calculatorType;
  final double? coveragePerBox; // For box-based products (sq.m per box)
  final List<SheetWidth>? availableWidths; // For sheet-based products
  final double wastePercentage; // Waste percentage (default 5%)

  const ProductCalculatorConfig({
    required this.productType,
    required this.calculatorType,
    this.coveragePerBox,
    this.availableWidths,
    this.wastePercentage = 5.0,
  });

  // Factory constructors for common product types
  static ProductCalculatorConfig boxBased({
    required double coveragePerBox,
    double wastePercentage = 5.0,
  }) {
    return ProductCalculatorConfig(
      productType: ProductType.boxBased,
      calculatorType: CalculatorType.enabled,
      coveragePerBox: coveragePerBox,
      wastePercentage: wastePercentage,
    );
  }

  static ProductCalculatorConfig carpet({double wastePercentage = 5.0}) {
    return ProductCalculatorConfig(
      productType: ProductType.carpet,
      calculatorType: CalculatorType.enabled,
      availableWidths: SheetWidth.getCarpetWidths(),
      wastePercentage: wastePercentage,
    );
  }

  static ProductCalculatorConfig vinyl({double wastePercentage = 5.0}) {
    return ProductCalculatorConfig(
      productType: ProductType.vinyl,
      calculatorType: CalculatorType.enabled,
      availableWidths: SheetWidth.getVinylWidths(),
      wastePercentage: wastePercentage,
    );
  }

  static ProductCalculatorConfig disabled() {
    return const ProductCalculatorConfig(
      productType: ProductType.simple,
      calculatorType: CalculatorType.disabled,
    );
  }
}
