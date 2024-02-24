import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/add_additional_item_modal_dialog_controller.dart';
import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../domain/usecase/add_additional_item_use_case.dart';
import '../../../domain/usecase/change_additional_item_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/string_util.dart';
import '../../../misc/textinputformatter/currency_text_input_formatter.dart';
import '../../../misc/validation/validator/validator.dart';
import '../../../misc/widget_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/field.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/password_obscurer.dart';
import '../../widget/rx_consumer.dart';
import '../../widget/sized_outline_gradient_button_app_bar_header.dart';
import 'modal_dialog_page.dart';

class AddAdditionalItemModalDialogPage extends ModalDialogPage<AddAdditionalItemModalDialogController> {
  final String? serializedJsonAdditionalItemModalDialogParameter;

  AddAdditionalItemModalDialogController get addAdditionalItemModalDialogController => modalDialogController.controller;

  AddAdditionalItemModalDialogPage({
    Key? key,
    this.serializedJsonAdditionalItemModalDialogParameter
  }) : super(key: key);

  @override
  AddAdditionalItemModalDialogController onCreateModalDialogController() {
    return AddAdditionalItemModalDialogController(
      controllerManager,
      Injector.locator<AddAdditionalItemUseCase>(),
      Injector.locator<ChangeAdditionalItemUseCase>(),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulAddAdditionalItemControllerMediatorWidget(
      addAdditionalItemModalDialogController: addAdditionalItemModalDialogController,
      serializedJsonAdditionalItemModalDialogParameter: serializedJsonAdditionalItemModalDialogParameter
    );
  }
}

class _StatefulAddAdditionalItemControllerMediatorWidget extends StatefulWidget {
  final AddAdditionalItemModalDialogController addAdditionalItemModalDialogController;
  final String? serializedJsonAdditionalItemModalDialogParameter;

  const _StatefulAddAdditionalItemControllerMediatorWidget({
    required this.addAdditionalItemModalDialogController,
    required this.serializedJsonAdditionalItemModalDialogParameter
  });

  @override
  State<_StatefulAddAdditionalItemControllerMediatorWidget> createState() => _StatefulAddAdditionalItemControllerMediatorWidgetState();
}

class _StatefulAddAdditionalItemControllerMediatorWidgetState extends State<_StatefulAddAdditionalItemControllerMediatorWidget> {
  final TextEditingController _additionalNameTextEditingController = TextEditingController();
  final TextEditingController _additionalEstimationPriceTextEditingController = TextEditingController();
  final TextEditingController _additionalEstimationWeightTextEditingController = TextEditingController();
  final TextEditingController _additionalQuantityTextEditingController = TextEditingController();
  final TextEditingController _additionalNotesTextEditingController = TextEditingController();
  String _id = "";

  final CurrencyTextInputFormatter currencyTextInputFormatter = CurrencyTextInputFormatter(
    locale: "in_ID",
    symbol: "",
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    if (widget.serializedJsonAdditionalItemModalDialogParameter.isNotEmptyString) {
      AdditionalItem additionalItem = widget.serializedJsonAdditionalItemModalDialogParameter!.toAddAdditionalItemModalDialogParameter().additionalItem;
      _id = additionalItem.id;
      _additionalNameTextEditingController.text = additionalItem.name;
      _additionalEstimationPriceTextEditingController.text = currencyTextInputFormatter.formatDouble(additionalItem.estimationPrice);
      _additionalEstimationWeightTextEditingController.text = additionalItem.estimationWeight.toString();
      _additionalQuantityTextEditingController.text = additionalItem.quantity.toString();
      _additionalNotesTextEditingController.text = additionalItem.notes.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.addAdditionalItemModalDialogController.setAddAdditionalItemModalDialogDelegate(
      AddAdditionalItemModalDialogDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetHasParameter: () => widget.serializedJsonAdditionalItemModalDialogParameter.isNotEmptyString,
        onGetAdditionalItemIdInput: () => _id,
        onGetAdditionalItemNameInput: () => _additionalNameTextEditingController.text,
        onGetAdditionalItemEstimationPriceInput: () => StringUtil.filterNumber(_additionalEstimationPriceTextEditingController.text),
        onGetAdditionalItemEstimationWeightInput: () => StringUtil.filterNumberAndDecimal(_additionalEstimationWeightTextEditingController.text),
        onGetAdditionalItemQuantityInput: () => _additionalQuantityTextEditingController.text,
        onGetAdditionalItemNotesInput: () => _additionalNotesTextEditingController.text,
        onAddAdditionalItemBack: () => Get.back(),
        onShowAdditionalItemRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onAddAdditionalItemRequestProcessSuccessCallback: (addAdditionalItemModalDialogResponse, base64StringAddAdditionalItemModalDialogResponse) async {
          Get.back(result: base64StringAddAdditionalItemModalDialogResponse);
        },
        onShowAdditionalItemRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
      )
    );
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedOutlineGradientButtonAppBarHeader(
              text: "Send the Goods to WH".tr
            ),
            const SizedBox(height: 20),
            Text("Item Name".tr),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.addAdditionalItemModalDialogController.additionalItemNameValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  controller: _additionalNameTextEditingController,
                  decoration: DefaultInputDecoration(hintText: "Input item name".tr),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            Text("Estimation Price".tr),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.addAdditionalItemModalDialogController.additionalItemEstimationPriceValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  inputFormatters: [currencyTextInputFormatter],
                  controller: _additionalEstimationPriceTextEditingController,
                  decoration: DefaultInputDecoration(
                    hintText: "Enter estimation price".tr,
                    prefixIcon: WidgetHelper.buildPrefixForTextField(
                      prefix: Text(
                        "Rp. ",
                        style: TextStyle(color: Constant.colorDarkBlack, fontSize: 16)
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0)
                  ),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            Text("Estimation Weight".tr),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.addAdditionalItemModalDialogController.additionalItemEstimationWeightValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  controller: _additionalEstimationWeightTextEditingController,
                  decoration: DefaultInputDecoration(
                    hintText: "Enter estimation weight".tr,
                    suffixIcon: WidgetHelper.buildSuffixForTextField(
                      suffix: Text(
                        "Kg",
                        style: TextStyle(color: Constant.colorDarkBlack, fontSize: 16)
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0)
                  ),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            Text("Quantity".tr),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.addAdditionalItemModalDialogController.additionalItemQuantityValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  controller: _additionalQuantityTextEditingController,
                  decoration: DefaultInputDecoration(hintText: "Enter quantity".tr),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            Text("Note".tr),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.addAdditionalItemModalDialogController.additionalItemNotesValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  controller: _additionalNotesTextEditingController,
                  decoration: DefaultInputDecoration(hintText: "Enter note".tr),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            SizedOutlineGradientButton(
              onPressed: widget.addAdditionalItemModalDialogController.createOrChangeAdditionalItem,
              text: widget.serializedJsonAdditionalItemModalDialogParameter.isNotEmptyString ? "Change".tr : "Add".tr,
              outlineGradientButtonType: OutlineGradientButtonType.solid,
              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
            ),
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    _additionalNameTextEditingController.dispose();
    _additionalEstimationPriceTextEditingController.dispose();
    _additionalEstimationWeightTextEditingController.dispose();
    _additionalQuantityTextEditingController.dispose();
    super.dispose();
  }
}