import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';

import '../../controller/modaldialogcontroller/add_additional_item_modal_dialog_controller.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../page/modaldialogpage/add_additional_item_modal_dialog_page.dart';
import 'tap_area.dart';

class AdditionalItemWidget extends StatelessWidget {
  final AdditionalItem additionalItem;
  final int? no;
  final void Function(AdditionalItem)? onRemoveAdditionalItem;
  final void Function() onLoadAdditionalItem;
  final bool showEditAndRemoveIcon;

  const AdditionalItemWidget({
    super.key,
    required this.additionalItem,
    this.no,
    this.onRemoveAdditionalItem,
    required this.onLoadAdditionalItem,
    required this.showEditAndRemoveIcon
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Text("${no != null ? "$no. " : ""}${additionalItem.name}")
              ),
              if (showEditAndRemoveIcon) ...[
                const SizedBox(width: 12),
                TapArea(
                  onTap: () async {
                    dynamic result = await DialogHelper.showModalDialogPage<String, String>(
                      context: context,
                      modalDialogPageBuilder: (context, parameter) => AddAdditionalItemModalDialogPage(
                        serializedJsonAdditionalItemModalDialogParameter: parameter
                      ),
                      parameter: AddAdditionalItemModalDialogResponse(
                        additionalItem: additionalItem
                      ).toEncodeBase64String()
                    );
                    if (result != null) {
                      onLoadAdditionalItem();
                    }
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                  )
                ),
                const SizedBox(width: 16),
                TapArea(
                  onTap: () async {
                    if (onRemoveAdditionalItem != null) {
                      onRemoveAdditionalItem!(additionalItem);
                    }
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 16,
                  )
                )
              ]
            ],
          )
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            children: [
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Estimation Price".tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text(additionalItem.estimationPrice.toRupiah(), style: const TextStyle(fontSize: 11))
                  ]
                )
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Estimation Weight".tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text("${additionalItem.estimationWeight} Kg", style: const TextStyle(fontSize: 11))
                  ]
                )
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quantity".tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text("${additionalItem.quantity}", style: const TextStyle(fontSize: 11))
                  ]
                )
              )
            ]
          ),
        )
      ]
    );
  }
}