import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension NumExt on num? {
  String withSeparator() {
    return NumberFormat.decimalPattern("id").format(this ?? 0);
  }

  IsZeroResult get isZeroResult {
    if (this is int) {
      num effectiveNum = this ?? 0;
      return IsZeroResult(
        isZero: effectiveNum == 0,
        effectiveNum: effectiveNum
      );
    } else if (this is double) {
      num effectiveNum = this ?? 0.0;
      return IsZeroResult(
        isZero: effectiveNum == 0.0,
        effectiveNum: effectiveNum
      );
    } else {
      return IsZeroResult(
        isZero: true,
        effectiveNum: this ?? 0
      );
    }
  }

  String toRupiah({bool withFreeTextIfZero = true}) {
    IsZeroResult zeroResult = isZeroResult;
    if (zeroResult.isZero) {
      if (withFreeTextIfZero) {
        return "Free".tr;
      }
    }
    return NumberFormat.currency(locale: "id", symbol: "Rp", decimalDigits: 0).format(zeroResult.effectiveNum);
  }

  bool hasDecimal() {
    return this != this?.floorToDouble();
  }

  String toDecimalStringIfHasDecimalValue() {
    bool hasDecimalResult = hasDecimal();
    if (hasDecimalResult) {
      return toString();
    } else {
      return this!.toInt().toString();
    }
  }
}

class IsZeroResult {
  final bool isZero;
  final num effectiveNum;

  IsZeroResult({
    required this.isZero,
    required this.effectiveNum
  });
}