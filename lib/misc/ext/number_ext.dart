import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../string_util.dart';

extension NumExt on num? {
  String withSeparator() {
    return NumberFormat.decimalPattern("id").format(this ?? 0);
  }

  String toWeightStringDecimalPlaced() {
    String result = toLocalizedStringAsFixed(3);
    String newResult = "";
    int step = 1;
    int i = result.length - 1;
    while (i >= 0) {
      String c = result[i];
      if (step == 1) {
        if (c != "0") {
          step = 2;
          newResult = "${c == "," ? "" : c}$newResult";
        }
      } else {
        newResult = "$c$newResult";
      }
      i--;
    }
    return newResult;
  }

  String toLocalizedStringAsFixed(int fractionDigits) {
    NumberFormat numberFormat = NumberFormat.decimalPattern("id");
    numberFormat.minimumFractionDigits = fractionDigits;
    numberFormat.maximumFractionDigits = fractionDigits;
    return numberFormat.format(this ?? 0);
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