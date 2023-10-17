abstract class HorizontalScalable {
  HorizontalScalableValue get horizontalScalableValue;
}

class HorizontalScalableValue {
  double? _scalableItemWidth;
  double? Function(double?)? scalableItemWidthGetterChecking;
  double? get scalableItemWidth {
    if (scalableItemWidthGetterChecking == null) {
      return _scalableItemWidth;
    }
    return scalableItemWidthGetterChecking!(_scalableItemWidth);
  }
  set scalableItemWidth(double? value) => _scalableItemWidth = value;

  HorizontalScalableValue({
    required double? scalableItemWidth,
    this.scalableItemWidthGetterChecking
  }) : _scalableItemWidth = scalableItemWidth;
}