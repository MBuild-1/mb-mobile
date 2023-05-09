import '../summaryvalue/summary_value.dart';

class CartSummary {
  List<SummaryValue> cartSummaryValue;
  List<SummaryValue> finalCartSummaryValue;

  CartSummary({
    required this.cartSummaryValue,
    required this.finalCartSummaryValue,
  });
}