import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/cart_summary_cart_modal_dialog_controller.dart';
import '../../../domain/entity/cart/cart_summary.dart';
import '../../../domain/entity/summaryvalue/summary_value.dart';
import '../../../domain/usecase/get_cart_summary_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../widget/horizontal_justified_title_and_description.dart';
import '../../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../../widget/modified_divider.dart';
import '../../widget/rx_consumer.dart';
import 'modal_dialog_page.dart';

class CartSummaryCartModalDialogPage extends ModalDialogPage<CartSummaryCartModalDialogController> {
  CartSummaryCartModalDialogController get cartSummaryCartModalDialogController => modalDialogController.controller;

  final CartSummary cartSummary;

  CartSummaryCartModalDialogPage({
    Key? key,
    required this.cartSummary
  }) : super(key: key);

  @override
  CartSummaryCartModalDialogController onCreateModalDialogController() {
    return CartSummaryCartModalDialogController(
      controllerManager,
      Injector.locator<GetCartSummaryUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCartSummaryControllerMediatorWidget(
      cartSummaryCartModalDialogController: cartSummaryCartModalDialogController,
      cartSummary: cartSummary
    );
  }
}

class _StatefulCartSummaryControllerMediatorWidget extends StatefulWidget {
  final CartSummaryCartModalDialogController cartSummaryCartModalDialogController;
  final CartSummary cartSummary;

  const _StatefulCartSummaryControllerMediatorWidget({
    required this.cartSummaryCartModalDialogController,
    required this.cartSummary
  });

  @override
  State<_StatefulCartSummaryControllerMediatorWidget> createState() => _StatefulCartSummaryControllerMediatorWidgetState();
}

class _StatefulCartSummaryControllerMediatorWidgetState extends State<_StatefulCartSummaryControllerMediatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: RxConsumer<LoadDataResultWrapper<CartSummary>>(
        rxValue: widget.cartSummaryCartModalDialogController.cartSummaryLoadDataResultWrapperRx,
        onConsumeValue: (context, cartSummaryLoadDataResultWrapper) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                CartSummary cartSummary = widget.cartSummary;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cart Summary".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                      ),
                    ),
                    const SizedBox(height: 10),
                    Builder(
                      builder: (BuildContext context) {
                        return cartSummaryWidget(cartSummary.cartSummaryValue);
                      }
                    ),
                    const SizedBox(height: 10),
                    const ModifiedDivider(),
                    const SizedBox(height: 10),
                    Builder(
                      builder: (BuildContext context) {
                        return cartSummaryWidget(
                          cartSummary.finalCartSummaryValue,
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
        )
      )
    );
  }

  Widget cartSummaryWidget(List<SummaryValue> cartSummaryValueList, {Widget Function(String, String)? onInterceptCartSummaryWidget}) {
    List<Widget> columnWidget = [];
    for (int i = 0; i < cartSummaryValueList.length; i++) {
      SummaryValue cartSummaryValue = cartSummaryValueList[i];
      if (i > 0) {
        columnWidget.add(const SizedBox(height: 10));
      }
      String cartSummaryValueDescription = "";
      String cartSummaryValueType = cartSummaryValue.type;
      if (cartSummaryValueType == "currency") {
        if (cartSummaryValue.value is num) {
          cartSummaryValueDescription = (cartSummaryValue.value as num).toRupiah();
        } else {
          cartSummaryValueDescription = double.parse(cartSummaryValue.value as String).toRupiah();
        }
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