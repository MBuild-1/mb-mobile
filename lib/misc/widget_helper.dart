import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/double_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../domain/entity/product/productbundle/product_bundle.dart';
import '../domain/entity/summaryvalue/summary_value.dart';
import '../presentation/notifier/product_notifier.dart';
import '../presentation/page/modaldialogpage/payment_instruction_modal_dialog_page.dart';
import '../presentation/widget/button/add_or_remove_cart_button.dart';
import '../presentation/widget/button/add_or_remove_wishlist_button.dart';
import '../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../presentation/widget/colorful_chip.dart';
import '../presentation/widget/countdown_indicator.dart';
import '../presentation/widget/horizontal_justified_title_and_description.dart';
import '../presentation/widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../presentation/widget/modified_divider.dart';
import '../presentation/widget/modified_shimmer.dart';
import '../presentation/widget/modified_svg_picture.dart';
import '../presentation/widget/modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../presentation/widget/modifiedcachednetworkimage/summary_value_modified_cached_network_image.dart';
import '../presentation/widget/productbundle/product_bundle_item.dart';
import '../presentation/widget/prompt_indicator.dart';
import '../presentation/widget/tap_area.dart';
import 'additionalsummarywidgetparameter/additional_summary_widget_parameter.dart';
import 'additionalsummarywidgetparameter/order_transaction_additional_summary_widget_parameter.dart';
import 'color_helper.dart';
import 'constant.dart';
import 'constrained_app_bar_return_value.dart';
import 'countdown/countdown_component_delegate.dart';
import 'date_util.dart';
import 'defaultloaddataresultwidget/main_default_load_data_result_widget.dart';
import 'dialog_helper.dart';
import 'error/token_empty_error.dart';
import 'errorprovider/error_provider.dart';
import 'load_data_result.dart';
import 'login_helper.dart';
import 'multi_language_string.dart';
import 'page_restoration_helper.dart';
import 'response_wrapper.dart';
import 'toast_helper.dart';
import 'web_helper.dart';

typedef _OnInterceptSummaryWidget = Widget Function(String, String, SummaryValue, HorizontalJustifiedTitleAndDescription);

class _WidgetHelperImpl {
  Widget buildPrefixForTextField({
    required Widget prefix
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          prefix,
          const SizedBox(height: 2)
        ],
      ),
    );
  }

  Widget buildSuffixForTextField({
    required Widget suffix
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          suffix,
          const SizedBox(height: 2)
        ],
      ),
    );
  }

  Widget buildPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText,
    String? promptText,
    String? buttonText,
    VoidCallback? onPressed,
    required PromptIndicatorType promptIndicatorType
  }) {
    return PromptIndicator(
      image: image,
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText ?? "OK",
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildSuccessPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText = "Success",
    String? promptText = "This process has been success...",
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    return buildPromptIndicator(
      context: context,
      image: image ?? Image.asset(Constant.imageSuccess),
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildFailedPromptIndicator({
    required BuildContext context,
    Image? image,
    String? promptTitleText,
    String? promptText,
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    return buildPromptIndicator(
      context: context,
      image: image ?? Image.asset(Constant.imageFailed),
      promptTitleText: promptTitleText,
      promptText: promptText,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  Widget buildFailedPromptIndicatorFromErrorProvider({
    required BuildContext context,
    required ErrorProvider errorProvider,
    required dynamic e,
    String? buttonText,
    VoidCallback? onPressed,
    PromptIndicatorType promptIndicatorType = PromptIndicatorType.vertical
  }) {
    ErrorProviderResult? errorProviderResult = errorProvider.onGetErrorProviderResult(e);
    return buildPromptIndicator(
      context: context,
      image: errorProviderResult != null ? Image.asset(errorProviderResult.imageAssetUrl.isEmpty ? Constant.imageFailed : errorProviderResult.imageAssetUrl) : null,
      promptTitleText: errorProviderResult?.title,
      promptText: errorProviderResult?.message,
      buttonText: buttonText,
      onPressed: onPressed,
      promptIndicatorType: promptIndicatorType
    );
  }

  double getAppBarAndStatusHeight(AppBar appBar, BuildContext context) {
    return appBar.preferredSize.height + MediaQuery.of(context).viewPadding.top;
  }

  ConstrainedAppBarReturnValue constrainedAppBar({
    required AppBar appBar,
    Widget? appBarWidget,
    required BuildContext context
  }) {
    double appBarAndStatusHeight = WidgetHelper.getAppBarAndStatusHeight(appBar, context);
    return ConstrainedAppBarReturnValue(
      appBar: SizedBox(
        height: appBarAndStatusHeight,
        child: appBarWidget ?? appBar
      ),
      appBarAndStatusHeight: appBarAndStatusHeight,
    );
  }

  Widget checkingLogin(BuildContext context, Widget Function() resultIfHasBeenLogin, ErrorProvider errorProvider, {bool withIndexedStack = false}) {
    Widget notLogin() {
      return Center(
        child: LoadDataResultImplementerDirectlyWithDefault<String>(
          errorProvider: errorProvider,
          loadDataResult: FailedLoadDataResult.throwException(() => throw TokenEmptyError())!,
          onImplementLoadDataResultDirectlyWithDefault: (loadDataResult, errorProvider, defaultLoadDataResultWidget) {
            return defaultLoadDataResultWidget.failedLoadDataResultWithButtonWidget(
              context,
              loadDataResult as FailedLoadDataResult<String>,
              errorProvider,
              failedLoadDataResultConfig: FailedLoadDataResultConfig(
                onPressed: () => PageRestorationHelper.toLoginPage(context, Constant.restorableRouteFuturePush),
                buttonText: "Login".tr
              )
            );
          }
        ),
      );
    }
    bool loginTokenIsNotEmpty = LoginHelper.getTokenWithBearer().result.isNotEmpty;
    if (withIndexedStack) {
      return IndexedStack(
        index: loginTokenIsNotEmpty ? 0 : 1,
        children: [
          resultIfHasBeenLogin(),
          notLogin()
        ],
      );
    }
    if (loginTokenIsNotEmpty) {
      return resultIfHasBeenLogin();
    }
    return notLogin();
  }

  Widget checkVisibility(bool? visibility, Widget Function() resultIfVisibilityIsTrue) {
    if (visibility == null) {
      return const SizedBox();
    }
    if (visibility) {
      return resultIfVisibilityIsTrue();
    }
    return const SizedBox();
  }

  Widget productBundleWishlistAndCartIndicator({
    required ProductBundle productBundle,
    required bool comingSoon,
    required OnAddWishlistWithProductBundle? onAddWishlist,
    required OnRemoveWishlistWithProductBundle? onRemoveWishlist,
    required OnAddCartWithProductBundle? onAddCart,
    required OnRemoveCartWithProductBundle? onRemoveCart,
  }) {
    void onWishlist(void Function(ProductBundle)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        onWishlistCallback(productBundle);
      }
    }
    return Consumer<ProductNotifier>(
      builder: (_, productNotifier, __) {
        LoadDataResult<bool> isAddToWishlist = productNotifier.isAddToWishlist(productBundle);
        LoadDataResult<bool> isAddToCart = productNotifier.isAddToCart(productBundle);
        return Row(
          children: [
            Builder(
              builder: (context) {
                Widget result = AddOrRemoveWishlistButton(
                  onAddWishlist: onAddWishlist != null ? () => onWishlist(onAddWishlist) : null,
                  onRemoveWishlist: onRemoveWishlist != null ? () => onWishlist(onRemoveWishlist) : null,
                  isAddToWishlist: isAddToWishlist.isSuccess ? isAddToWishlist.resultIfSuccess! : false,
                );
                return isAddToWishlist.isSuccess ? result : ModifiedShimmer.fromColors(child: result);
              }
            ),
            SizedBox(width: 1.5.w),
            Builder(
              builder: (context) {
                void Function()? onPressed = !comingSoon ? (onAddCart != null ? () => onAddCart(productBundle) : null) : null;
                Widget result = AddOrRemoveCartButton(
                  onAddCart: onPressed,
                  isAddToCart: isAddToCart.isSuccess ? isAddToCart.resultIfSuccess! : false,
                  isIcon: true,
                  isLoading: !isAddToCart.isSuccess
                );
                return Expanded(
                  child: isAddToCart.isSuccess ? result : ModifiedShimmer.fromColors(child: result)
                );
              }
            )
          ],
        );
      }
    );
  }

  Widget selectVerificationMethod({
    required Widget icon,
    required Widget title,
    required Widget description,
    void Function()? onTap
  }) {
    return TapArea(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade400)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 3),
                  description
                ]
              )
            )
          ],
        )
      ),
    );
  }

  List<Widget> summaryWidgetList(
    List<SummaryValue> summaryValueList,
    {_OnInterceptSummaryWidget? onInterceptSummaryWidget, AdditionalSummaryWidgetParameter? additionalSummaryWidgetParameter}
  ) {
    List<Widget> columnWidget = [];
    for (int i = 0; i < summaryValueList.length; i++) {
      SummaryValue summaryValue = summaryValueList[i];
      String? summaryValueDescription;
      String summaryValueType = summaryValue.type;
      void addSpacing() {
        if (columnWidget.isNotEmpty) {
          double height = 10.0;
          if (summaryValueType == "header") {
            height = 15.0;
          }
          columnWidget.add(SizedBox(height: height));
        }
      }
      void addColumnWidget(Widget widget) {
        addSpacing();
        columnWidget.add(widget);
      }
      void addColumnWidgetList(List<Widget> widgetList) {
        addSpacing();
        columnWidget.addAll(widgetList);
      }
      if (summaryValueType == "currency") {
        if (summaryValue.value is num) {
          summaryValueDescription = (summaryValue.value as num).toRupiah(withFreeTextIfZero: false);
        } else {
          summaryValueDescription = (summaryValue.value as String).parseDoubleWithAdditionalChecking().toRupiah(withFreeTextIfZero: false);
        }
      } else if (summaryValueType == "header") {
        addColumnWidget(
          HorizontalJustifiedTitleAndDescription(
            title: summaryValue.name.toEmptyStringNonNull,
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
      } else if (summaryValueType == "countdown_component") {
        Widget? countdownIndicatorResultWidget;
        CountdownComponentDelegate countdownComponentDelegate = summaryValue.value;
        Widget countdownIndicator = CountdownIndicator(
          countdownComponentDelegate: countdownComponentDelegate
        );
        if (countdownComponentDelegate is DefaultCountdownComponentDelegate) {
          dynamic tag = countdownComponentDelegate.tag;
          if (tag is DefaultCountdownComponentDelegateTagData) {
            String expiredDateString = DateUtil.standardDateFormat6.format(tag.expiredDateTime);
            countdownIndicatorResultWidget = Column(
              children: [
                countdownIndicator,
                const SizedBox(height: 10),
                Text(
                  MultiLanguageString({
                    Constant.textInIdLanguageKey: "Menunggu Konfirmasi Pembayaran",
                    Constant.textEnUsLanguageKey: "Waiting for Payment Confirmation"
                  }).toStringNonNull,
                  style: TextStyle(
                    color: Constant.colorGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: MultiLanguageString({
                          Constant.textInIdLanguageKey: "Selesaikan pembayaran sebelum\r\n",
                          Constant.textEnUsLanguageKey: "Waiting for Payment Confirmatio\r\n"
                        }).toStringNonNull
                      ),
                      TextSpan(
                        text: expiredDateString,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                  textAlign: TextAlign.center,
                ),
                if (tag.onRefresh != null) ...[
                  const SizedBox(height: 4),
                  TapArea(
                    onTap: tag.onRefresh,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Constant.colorMain
                        ),
                        const SizedBox(width: 5),
                        Text(
                          MultiLanguageString({
                            Constant.textInIdLanguageKey: "Cek Status Pembayaran",
                            Constant.textEnUsLanguageKey: "Check Payment Status"
                          }).toStringNonNull,
                          style: TextStyle(
                            color: Constant.colorMain,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ]
              ],
            );
          }
        }
        countdownIndicatorResultWidget ??= countdownIndicator;
        addColumnWidget(countdownIndicatorResultWidget);
        continue;
      } else if (summaryValueType == "countdown") {
        addColumnWidget(
          HorizontalJustifiedTitleAndDescription(
            title: summaryValue.name.toEmptyStringNonNull,
            titleWidgetInterceptor: (value, textWidget) {
              return Text(value.toEmptyStringNonNull);
            },
            description: summaryValue.value.toString(),
            descriptionWidgetInterceptor: (value, textWidget) {
              return Text(value.toStringNonNull);
            },
          )
        );
        continue;
      } else if (summaryValueType == "copyable_text") {
        addColumnWidget(
          HorizontalJustifiedTitleAndDescription(
            title: summaryValue.name.toEmptyStringNonNull,
            titleWidgetInterceptor: (value, textWidget) {
              return Row(
                children: [
                  Text(value.toEmptyStringNonNull),
                  const SizedBox(width: 8.0),
                  TapArea(
                    onTap: () {
                      dynamic rawClipboardData = summaryValue.value;
                      ClipboardData? clipboardData;
                      if (rawClipboardData is String) {
                        clipboardData = ClipboardData(text: rawClipboardData);
                      } else if (rawClipboardData is num) {
                        clipboardData = ClipboardData(text: rawClipboardData.toString());
                      }
                      if (clipboardData != null) {
                        Clipboard.setData(clipboardData);
                        ToastHelper.showToast("${"Success copied".tr}.");
                      } else {
                        ToastHelper.showToast("${"Cannot copy this content".tr}.");
                      }
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 18
                    )
                  ),
                ],
              );
            },
            description: summaryValue.value.toString(),
            descriptionWidgetInterceptor: (value, textWidget) {
              return Text(
                value.toEmptyStringNonNull
              );
            },
          )
        );
        continue;
      } else if (summaryValueType == "image") {
        dynamic value = summaryValue.value;
        if (value is Map<String, dynamic>) {
          Widget imageWidget = SizedBox(
            width: ResponseWrapper(value["image_width"]).mapFromResponseToDouble(),
            height: ResponseWrapper(value["image_height"]).mapFromResponseToDouble(),
            child: SummaryValueModifiedCachedNetworkImage(
              imageUrl: (value["image_url"] as String?).toEmptyStringNonNull,
              boxFit: () {
                String? imageBoxFit = value["image_box_fit"] as String?;
                if (imageBoxFit == "fill") {
                  return BoxFit.fill;
                } else if (imageBoxFit == "contain") {
                  return BoxFit.contain;
                } else if (imageBoxFit == "cover") {
                  return BoxFit.cover;
                } else if (imageBoxFit == "fit_width") {
                  return BoxFit.fitWidth;
                } else if (imageBoxFit == "fit_height") {
                  return BoxFit.fitHeight;
                } else if (imageBoxFit == "none") {
                  return BoxFit.none;
                } else if (imageBoxFit == "scale_down") {
                  return BoxFit.scaleDown;
                }
                return null;
              }()
            ),
          );
          bool withLabelName = value["image_with_label_name"] ?? false;
          if (withLabelName) {
            if (summaryValue.name.isNotEmptyString) {
              addColumnWidget(
                HorizontalJustifiedTitleAndDescription(
                  title: summaryValue.name.toEmptyStringNonNull,
                  titleWidgetInterceptor: (value, textWidget) {
                    return Text(value.toEmptyStringNonNull);
                  },
                  description: summaryValue.value.toString(),
                  descriptionWidgetInterceptor: (value, textWidget) {
                    return imageWidget;
                  },
                )
              );
              continue;
            }
          }
          addColumnWidget(imageWidget);
        }
        continue;
      } else if (summaryValueType == "redirect_url") {
        dynamic value = summaryValue.value;
        if (value is String) {
          addColumnWidget(
            SizedOutlineGradientButton(
              onPressed: () => WebHelper.launchUrl(Uri.parse(value)),
              text: summaryValue.name.toEmptyStringNonNull,
              customPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              outlineGradientButtonType: OutlineGradientButtonType.solid,
              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
            )
          );
        }
        continue;
      } else if (summaryValueType == "chip") {
        dynamic summaryValueContent = summaryValue.value;
        if (summaryValueContent is Map<String, dynamic>) {
          Color color = ColorHelper.fromHex(summaryValueContent["color"]);
          addColumnWidget(
            HorizontalJustifiedTitleAndDescription(
              title: summaryValue.name.toEmptyStringNonNull,
              titleWidgetInterceptor: (value, textWidget) {
                return Text(value.toEmptyStringNonNull);
              },
              description: summaryValue.value.toString(),
              descriptionWidgetInterceptor: (value, textWidget) {
                return ColorfulChip(
                  text: summaryValueContent["text"],
                  textStyle: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: ColorHelper.contrastColorFromBackgroundColor(color)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  color: color
                );
              },
            )
          );
        }
        continue;
      } else if (summaryValueType == "payment_instruction") {
        continue;
      } else if (summaryValueType == "custome_text" || summaryValueType == "custom_text") {
        continue;
      } else if (summaryValueType == "button") {
        dynamic summaryValueContent = summaryValue.value;
        if (summaryValueContent is Map<String, dynamic>) {
          String? tagString = summaryValueContent["tag_string"];
          if (tagString == "payment_instruction") {
            addColumnWidgetList(
              <Widget>[
                if (i == summaryValueList.length - 1) ...[
                  const SizedBox(height: 6),
                  const ModifiedDivider(),
                  const SizedBox(height: 10),
                ],
                Builder(
                  builder: (context) {
                    Color primaryColor = Theme.of(context).colorScheme.primary;
                    TextStyle textStyle = TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                    );
                    return TapArea(
                      onTap: additionalSummaryWidgetParameter is OrderTransactionAdditionalSummaryWidgetParameter ? () {
                        DialogHelper.showModalBottomDialogPage<int, int>(
                          context: context,
                          modalDialogPageBuilder: (context, parameter) => PaymentInstructionModalDialogPage(
                            paymentInstructionModalDialogPageParameter: PaymentInstructionModalDialogPageParameter(
                              paymentInstructionModalDialogPageDelegate: additionalSummaryWidgetParameter.paymentInstructionModalDialogPageDelegate,
                              paymentInstructionTransactionSummaryLoadDataResult: () {
                                return additionalSummaryWidgetParameter.orderTransactionResponseLoadDataResult.map<PaymentInstructionTransactionSummary>(
                                  (orderTransactionResponse) => orderTransactionResponse.paymentInstructionTransactionSummary
                                );
                              },
                              onGetErrorProvider: additionalSummaryWidgetParameter.onGetErrorProvider
                            ),
                          ),
                          parameter: 1
                        );
                      } : null,
                      child: HorizontalJustifiedTitleAndDescription(
                        title: summaryValue.name.toEmptyStringNonNull,
                        titleWidgetInterceptor: (value, textWidget) {
                          return Text("Payment Instruction".tr, style: textStyle);
                        },
                        description: summaryValue.value.toString(),
                        descriptionWidgetInterceptor: (value, textWidget) {
                          return ModifiedSvgPicture.asset(
                            Constant.vectorArrow,
                            color: primaryColor,
                            height: 12,
                          );
                        },
                      ),
                    );
                  }
                )
              ]
            );
          } else {
            String? link = summaryValueContent["link"] as String?;
            String colorHexString = (summaryValueContent["color"] as String?).toEmptyStringNonNull;
            Color color = ColorHelper.fromHex(colorHexString);
            TextStyle getDefaultTextStyle() {
              return TextStyle(
                color: Constant.colorDarkBlue,
                fontWeight: FontWeight.bold
              );
            }
            addColumnWidgetList(
              <Widget>[
                SizedOutlineGradientButton(
                  onPressed: link.isNotEmptyString ? () {
                    WebHelper.launchUrl(Uri.parse(link!));
                  } : null,
                  text: "Submit".tr,
                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                  childInterceptor: (textStyle) {
                    return SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            if (summaryValueContent["image"] != null) {
                              return SizedBox(
                                width: ResponseWrapper(summaryValueContent["image_width"]).mapFromResponseToDouble(),
                                height: ResponseWrapper(summaryValueContent["image_height"]).mapFromResponseToDouble(),
                                child: SummaryValueModifiedCachedNetworkImage(
                                  imageUrl: (summaryValueContent["image"] as String?).toEmptyStringNonNull,
                                  boxFit: () {
                                    return BoxFit.contain;
                                  }()
                                )
                              );
                            } else {
                              return Text(
                                (summaryValueContent["text"] as String?).toEmptyStringNonNull,
                                style: textStyle
                              );
                            }
                          }
                        ),
                      ),
                    );
                  },
                  customGradientButtonVariation: (outlineGradientButtonType) {
                    return CustomGradientButtonVariation(
                      outlineGradientButtonType: outlineGradientButtonType,
                      gradient: SweepGradient(
                        stops: const [1],
                        colors: [color],
                      ),
                      backgroundColor: color,
                      textStyle: getDefaultTextStyle()
                    );
                  },

                )
              ]
            );
          }
        }
        continue;
      } else {
        summaryValueDescription = summaryValue.value;
      }
      HorizontalJustifiedTitleAndDescription resultHorizontalJustifiedTitleAndDescription = HorizontalJustifiedTitleAndDescription(
        title: summaryValue.name.toEmptyStringNonNull,
        description: summaryValueDescription.toEmptyStringNonNull
      );
      addColumnWidget(
        onInterceptSummaryWidget != null ? onInterceptSummaryWidget(
          summaryValue.name.toEmptyStringNonNull,
          summaryValueDescription.toEmptyStringNonNull,
          summaryValue,
          resultHorizontalJustifiedTitleAndDescription,
        ) : resultHorizontalJustifiedTitleAndDescription
      );
    }
    return columnWidget;
  }

  Widget summaryWidget(List<SummaryValue> summaryValueList, {_OnInterceptSummaryWidget? onInterceptSummaryWidget, AdditionalSummaryWidgetParameter? additionalSummaryWidgetParameter}) {
    return Column(
      children: summaryWidgetList(
        summaryValueList,
        onInterceptSummaryWidget: onInterceptSummaryWidget,
        additionalSummaryWidgetParameter: additionalSummaryWidgetParameter
      )
    );
  }


  Widget buildWeightInputHint() {
    return Text(
      MultiLanguageString({
        Constant.textInIdLanguageKey: "Masukkan berat dalam kilogram dan gunakan koma (,) atau titik (.) sebagai pemisah desimal (contoh: 1,8 atau 1.8)",
        Constant.textEnUsLanguageKey: "Enter the weight in kilograms and use a comma (,) or dot (.) as the decimal separator (example: 1.8 or 1.8)"
      }).toEmptyStringNonNull,
      style: TextStyle(color: Constant.colorDarkGrey, fontSize: 12)
    );
  }
}

// ignore: non_constant_identifier_names
var WidgetHelper = _WidgetHelperImpl();