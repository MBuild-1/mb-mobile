import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/input_value_modal_dialog_controller.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/validation/validation_result.dart';
import '../../../misc/validation/validator/validator.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/field.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/rx_consumer.dart';
import '../../widget/sized_outline_gradient_button_app_bar_header.dart';
import 'modal_dialog_page.dart';

class InputValueModalDialogPage extends ModalDialogPage<InputValueModalDialogController> {
  final InputValueModalDialogPageParameter inputValueModalDialogPageParameter;

  InputValueModalDialogController get inputValueModalDialogController => modalDialogController.controller;

  InputValueModalDialogPage({
    Key? key,
    required this.inputValueModalDialogPageParameter
  }) : super(key: key);

  @override
  InputValueModalDialogController onCreateModalDialogController() {
    return InputValueModalDialogController(controllerManager);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulInputValueControllerMediatorWidget(
      inputValueModalDialogController: inputValueModalDialogController,
      inputValueModalDialogPageParameter: inputValueModalDialogPageParameter,
    );
  }
}

class _StatefulInputValueControllerMediatorWidget extends StatefulWidget {
  final InputValueModalDialogController inputValueModalDialogController;
  final InputValueModalDialogPageParameter inputValueModalDialogPageParameter;

  const _StatefulInputValueControllerMediatorWidget({
    required this.inputValueModalDialogController,
    required this.inputValueModalDialogPageParameter
  });

  @override
  State<_StatefulInputValueControllerMediatorWidget> createState() => __StatefulInputValueControllerMediatorWidgetState();
}

class __StatefulInputValueControllerMediatorWidgetState extends State<_StatefulInputValueControllerMediatorWidget> {
  final TextEditingController _inputValueTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputValueTextEditingController.text = widget.inputValueModalDialogPageParameter.value.toEmptyStringNonNull;
  }

  @override
  Widget build(BuildContext context) {
    widget.inputValueModalDialogController.setInputValueModalDialogDelegate(
      InputValueModalDialogDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetInputValueInput: () => _inputValueTextEditingController.text,
        onInputValueBack: () => Get.back(),
        onInputValueRequestProcessSuccessCallback: (note) async => Get.back(result: note),
        onGetInputValueRequiredMessage: widget.inputValueModalDialogPageParameter.requiredMessage,
        onValidateInput: widget.inputValueModalDialogPageParameter.onValidate
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
              text: "Host Cart".tr,
            ),
            const SizedBox(height: 20),
            Text(widget.inputValueModalDialogPageParameter.inputTitle()),
            const SizedBox(height: 10),
            RxConsumer<Validator>(
              rxValue: widget.inputValueModalDialogController.inputValidatorRx,
              onConsumeValue: (context, value) => Field(
                child: (context, validationResult, validator) => ModifiedTextField(
                  isError: validationResult.isFailed,
                  controller: _inputValueTextEditingController,
                  decoration: DefaultInputDecoration(hintText: widget.inputValueModalDialogPageParameter.inputHint()),
                  onChanged: (value) => validator?.validate(),
                  textInputAction: TextInputAction.next,
                ),
                validator: value,
              ),
            ),
            const SizedBox(height: 20),
            SizedOutlineGradientButton(
              onPressed: widget.inputValueModalDialogController.inputValue,
              text: widget.inputValueModalDialogPageParameter.inputSubmitText(),
              outlineGradientButtonType: OutlineGradientButtonType.solid,
              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
            ),
          ]
        )
      ),
    );
  }
}

class InputValueModalDialogPageParameter {
  final String? value;
  final String Function() title;
  final String Function() inputTitle;
  final String Function() inputHint;
  final String Function() inputSubmitText;
  final String Function() requiredMessage;
  final ValidationResult Function(String)? onValidate;

  const InputValueModalDialogPageParameter({
    required this.value,
    required this.title,
    required this.inputTitle,
    required this.inputHint,
    required this.inputSubmitText,
    required this.requiredMessage,
    this.onValidate
  });
}