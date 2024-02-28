import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/modaldialogcontroller/add_additional_item_modal_dialog_controller.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/with_image_additional_item.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../page/modaldialogpage/add_additional_item_modal_dialog_page.dart';
import 'modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import 'tap_area.dart';

class AdditionalItemWidget extends StatelessWidget {
  final AdditionalItem additionalItem;
  final int? no;
  final void Function(AdditionalItem)? onEditAdditionalItem;
  final void Function(AdditionalItem)? onRemoveAdditionalItem;
  final void Function() onLoadAdditionalItem;
  final bool showEditAndRemoveIcon;

  const AdditionalItemWidget({
    super.key,
    required this.additionalItem,
    this.no,
    this.onEditAdditionalItem,
    this.onRemoveAdditionalItem,
    required this.onLoadAdditionalItem,
    required this.showEditAndRemoveIcon
  });

  @override
  Widget build(BuildContext context) {
    Widget additionalItemAction = Row(
      children: [
        if (showEditAndRemoveIcon) ...[
          const SizedBox(width: 12),
          TapArea(
            onTap: () async {
              if (onEditAdditionalItem != null) {
                onEditAdditionalItem!(additionalItem);
                return;
              }
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
      ]
    );
    if (additionalItem is WithImageAdditionalItem) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                child: ProductModifiedCachedNetworkImage(
                  imageUrl: (additionalItem as WithImageAdditionalItem).imageUrl.toEmptyStringNonNull,
                )
              )
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  additionalItem.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  )
                ),
                const SizedBox(height: 3),
                Text(
                  "${"Price".tr}: ${additionalItem.estimationPrice.toRupiah()}",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  )
                ),
                const SizedBox(height: 3),
                Text(
                  "${"Weight".tr}: ${additionalItem.estimationWeight.toWeightStringDecimalPlaced()} Kg",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  )
                ),
                const SizedBox(height: 3),
                Text(
                  "${"Quantity".tr}: ${additionalItem.quantity.toString()}",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis
                  )
                ),
                if (additionalItem.notes.isNotEmptyString) ...[
                  const SizedBox(height: 3),
                  Text(
                    "${"Notes".tr}: ${additionalItem.quantity.toString()}",
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis
                    )
                  )
                ]
              ]
            ),
          ),
          const SizedBox(width: 12),
          additionalItemAction
        ]
      );
    }
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
              additionalItemAction
            ],
          )
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Estimation Price".tr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 3),
                        Text(additionalItem.estimationPrice.toRupiah(withFreeTextIfZero: false), style: const TextStyle(fontSize: 11))
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
                        Text("${additionalItem.estimationWeight.toWeightStringDecimalPlaced()} Kg", style: const TextStyle(fontSize: 11))
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
              if (additionalItem.notes.isNotEmptyString) ...[
                const SizedBox(height: 10.0),
                Text(
                  "${"Note".tr}: ${additionalItem.notes.toString()}",
                  style: const TextStyle(
                    fontSize: 11.0,
                    overflow: TextOverflow.ellipsis
                  )
                )
              ]
            ],
          ),
        )
      ]
    );
  }
}