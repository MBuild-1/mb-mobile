import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/multi_language_string.dart';

import '../../../misc/constant.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_divider.dart';

enum SharedCartAcceptOrDeclineMemberResult {
  accept, decline
}

class SharedCartMemberItem extends StatelessWidget {
  final int shoppingItemTotalCount;
  final double shoppingItemTotal;
  final double shoppingItemWeightTotal;
  final bool isExpanded;
  final void Function()? onTapDelete;
  final void Function()? onTapReady;
  final void Function()? onTapMore;
  final void Function(SharedCartAcceptOrDeclineMemberResult)? onAcceptOrDeclineMember;
  final bool showReadyButton;
  final bool showDeleteButton;
  final int readyStatus;

  const SharedCartMemberItem({
    super.key,
    required this.shoppingItemTotalCount,
    required this.shoppingItemTotal,
    required this.shoppingItemWeightTotal,
    required this.onTapDelete,
    required this.onTapReady,
    required this.isExpanded,
    required this.onTapMore,
    required this.onAcceptOrDeclineMember,
    required this.showReadyButton,
    required this.showDeleteButton,
    required this.readyStatus
  });

  @override
  Widget build(BuildContext context) {
    String totalShoppingItemLabel = MultiLanguageString({
      Constant.textInIdLanguageKey: "Total Barang Belanja",
      Constant.textEnUsLanguageKey: "Total Shopping Items"
    }).toStringNonNull;
    String totalShoppingLabel = MultiLanguageString({
      Constant.textInIdLanguageKey: "Total Belanja",
      Constant.textEnUsLanguageKey: "Shopping Total"
    }).toStringNonNull;
    String totalWeightLabel = MultiLanguageString({
      Constant.textInIdLanguageKey: "Total Berat",
      Constant.textEnUsLanguageKey: "Weight Total"
    }).toStringNonNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$totalShoppingItemLabel: ",
              ),
              TextSpan(
                text: "$shoppingItemTotalCount Item",
                style: const TextStyle(fontWeight: FontWeight.bold)
              )
            ]
          ),
        ),
        const SizedBox(height: 10),
        const ModifiedDivider(),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$totalShoppingLabel: ",
                        ),
                        TextSpan(
                          text: shoppingItemTotal.toRupiah(withFreeTextIfZero: false),
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        )
                      ]
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$totalWeightLabel: ",
                        ),
                        TextSpan(
                          text: "$shoppingItemWeightTotal Kg",
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        )
                      ]
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (onAcceptOrDeclineMember != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: SizedOutlineGradientButton(
                            onPressed: () => onAcceptOrDeclineMember!(SharedCartAcceptOrDeclineMemberResult.decline),
                            text: MultiLanguageString({
                              Constant.textInIdLanguageKey: "Tolak",
                              Constant.textEnUsLanguageKey: "Decline"
                            }).toStringNonNull,
                            outlineGradientButtonType: OutlineGradientButtonType.outline,
                            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                          )
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: SizedOutlineGradientButton(
                            onPressed: () => onAcceptOrDeclineMember!(SharedCartAcceptOrDeclineMemberResult.accept),
                            text: MultiLanguageString({
                              Constant.textInIdLanguageKey: "Setuju",
                              Constant.textEnUsLanguageKey: "Accept"
                            }).toStringNonNull,
                            outlineGradientButtonType: OutlineGradientButtonType.solid,
                            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                          )
                        )
                      ],
                    )
                  ] else ...[
                    Builder(
                      builder: (context) {
                        bool isTapDelete = showDeleteButton && onTapDelete != null;
                        bool isTapReady = showReadyButton && onTapReady != null;
                        bool isNotTapDeleteAndNotReady = !isTapDelete && !isTapReady;
                        bool isReady = readyStatus == 1;
                        return Row(
                          children: [
                            if (!isNotTapDeleteAndNotReady) ...[
                              Expanded(
                                child: SizedOutlineGradientButton(
                                  onPressed: () {
                                    if (isTapDelete) {
                                      return onTapDelete;
                                    } else if (isTapReady) {
                                      return onTapReady;
                                    }
                                    return null;
                                  }(),
                                  text: () {
                                    if (isTapDelete) {
                                      return MultiLanguageString({
                                        Constant.textInIdLanguageKey: "Hapus",
                                        Constant.textEnUsLanguageKey: "Delete"
                                      });
                                    } else if (isTapReady) {
                                      // If "Ready" then show "Not Ready" text, because this purpose of this button is to make "Not Ready" if tapped.
                                      // Else if "Not Ready" then show "Ready" text, because this purpose of this button is to make "Ready" if tapped.
                                      return MultiLanguageString({
                                        Constant.textInIdLanguageKey: isReady ? "Tidak Siap" : "Siap",
                                        Constant.textEnUsLanguageKey: isReady ? "Not Ready" : "Ready"
                                      });
                                    }
                                    return null;
                                  }().toStringNonNull,
                                  outlineGradientButtonType: OutlineGradientButtonType.outline,
                                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                )
                              ),
                              const SizedBox(width: 10.0),
                            ],
                            Expanded(
                              child: SizedOutlineGradientButton(
                                onPressed: onTapMore,
                                text: () {
                                  if (!isExpanded) {
                                    return MultiLanguageString({
                                      Constant.textInIdLanguageKey: "Selengkapnya",
                                      Constant.textEnUsLanguageKey: "More"
                                    });
                                  } else {
                                    return MultiLanguageString({
                                      Constant.textInIdLanguageKey: "Sembunyikan",
                                      Constant.textEnUsLanguageKey: "Hide"
                                    });
                                  }
                                }().toStringNonNull,
                                outlineGradientButtonType: OutlineGradientButtonType.solid,
                                outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                              )
                            )
                          ],
                        );
                      }
                    )
                  ]
                ]
              ),
            )
          ]
        )
      ]
    );
  }
}