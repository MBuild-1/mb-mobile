abstract class HorizontalScalable {
  HorizontalScalableValue get horizontalScalableValue;
}

class HorizontalScalableValue {
  double? scalableItemWidth;

  HorizontalScalableValue({
    required this.scalableItemWidth
  });
}