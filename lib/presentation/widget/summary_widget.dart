import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/summary/base_summary.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
import 'horizontal_justified_title_and_description.dart';
import 'modified_divider.dart';

class SummaryWidget extends StatelessWidget {
  final BaseSummary baseSummary;

  const SummaryWidget({
    super.key,
    required this.baseSummary
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return _summaryWidget(baseSummary.summaryValue);
                  }
                ),
                const SizedBox(height: 17),
                const ModifiedDivider(),
                const SizedBox(height: 10),
                Builder(
                  builder: (BuildContext context) {
                    return _summaryWidget(
                      baseSummary.finalSummaryValue,
                      onInterceptCartSummaryWidget: (name, description) {
                        return HorizontalJustifiedTitleAndDescription(
                          title: name,
                          description: description,
                          titleWidgetInterceptor: (title, widget) => Text(
                            title.toStringNonNull,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          descriptionWidgetInterceptor: (description, widget) => Text(
                            description.toStringNonNull,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                        );
                      }
                    );
                  }
                ),
              ]
            );
          }
        )
      ]
    );
  }

  Widget _summaryWidget(List<SummaryValue> cartSummaryValueList, {Widget Function(String, String)? onInterceptCartSummaryWidget}) {
    List<Widget> columnWidget = [];
    for (int i = 0; i < cartSummaryValueList.length; i++) {
      SummaryValue cartSummaryValue = cartSummaryValueList[i];
      String cartSummaryValueDescription = "";
      String cartSummaryValueType = cartSummaryValue.type;
      if (i > 0) {
        double height = 10.0;
        if (cartSummaryValueType == "header") {
          height = 15.0;
        }
        columnWidget.add(SizedBox(height: height));
      }
      if (cartSummaryValueType == "currency") {
        if (cartSummaryValue.value is num) {
          cartSummaryValueDescription = (cartSummaryValue.value as num).toRupiah(withFreeTextIfZero: false);
        } else {
          cartSummaryValueDescription = double.parse(cartSummaryValue.value as String).toRupiah(withFreeTextIfZero: false);
        }
      } else if (cartSummaryValueType == "header") {
        columnWidget.add(
          HorizontalJustifiedTitleAndDescription(
            title: cartSummaryValue.name,
            titleWidgetInterceptor: (value, textWidget) {
              return Text(
                value.toEmptyStringNonNull,
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            },
            description: "",
            descriptionWidgetInterceptor: (value, textWidget) {
              return const SizedBox();
            },
            hasDescription: false,
          )
        );
        continue;
      } else {
        cartSummaryValueDescription = cartSummaryValue.value;
      }
      columnWidget.add(
        onInterceptCartSummaryWidget != null ? onInterceptCartSummaryWidget(
          cartSummaryValue.name,
          cartSummaryValueDescription
        ) : HorizontalJustifiedTitleAndDescription(
          title: cartSummaryValue.name,
          description: cartSummaryValueDescription
        )
      );
    }
    return Column(
      children: columnWidget
    );
  }
}