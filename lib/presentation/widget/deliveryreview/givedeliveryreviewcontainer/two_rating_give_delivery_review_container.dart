import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';

import '../../../../controller/deliveryreviewcontroller/givedeliveryreviewcontainercontroller/two_rating_give_delivery_review_container_controller.dart';
import '../../../../domain/entity/delivery/givedeliveryreviewvalue/give_delivery_review_value.dart';
import '../../../../domain/entity/delivery/givedeliveryreviewvalue/two_rating_give_delivery_review_value.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/general_give_delivery_review_container_parameter.dart';
import '../../../../misc/getextended/get_extended.dart';
import '../../../../misc/give_delivery_review_container_submit_callback.dart';
import '../../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/multi_language_string.dart';
import '../../../../misc/validation/validator/validator.dart';
import '../../../page/getx_page.dart';
import '../../field.dart';
import '../../modified_svg_picture.dart';
import '../../modified_text_field.dart';
import '../../rx_consumer.dart';
import '../../tap_area.dart';
import '../givedeliveryreviewattachment/give_delivery_review_attachment_section.dart';

class TwoRatingGiveDeliveryReviewContainer extends DefaultGetxPage {
  late final ControllerMember<TwoRatingGiveDeliveryReviewContainerController> _twoRatingGiveDeliveryReviewContainerController;
  final TwoRatingGiveDeliveryReviewContainerData twoRatingGiveDeliveryReviewContainerData;
  final TwoRatingGiveDeliveryReviewContainerSubmitCallback twoRatingGiveDeliveryReviewContainerSubmitCallback;
  final String ancestorPageName;
  final void Function(GiveDeliveryReviewValue?) giveDeliveryReviewValueCallback;
  final ControllerMember<TwoRatingGiveDeliveryReviewContainerController> Function() onAddControllerMember;
  final GeneralGiveDeliveryReviewContainerParameter generalGiveDeliveryReviewContainerParameter;

  TwoRatingGiveDeliveryReviewContainer({
    super.key,
    required this.twoRatingGiveDeliveryReviewContainerData,
    required this.twoRatingGiveDeliveryReviewContainerSubmitCallback,
    required this.ancestorPageName,
    required this.giveDeliveryReviewValueCallback,
    required this.onAddControllerMember,
    required this.generalGiveDeliveryReviewContainerParameter,
  }) {
    _twoRatingGiveDeliveryReviewContainerController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _twoRatingGiveDeliveryReviewContainerController.controller = GetExtended.put<TwoRatingGiveDeliveryReviewContainerController>(
      TwoRatingGiveDeliveryReviewContainerController(
        controllerManager
      ),
      tag: ancestorPageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidget(
      twoRatingGiveDeliveryReviewContainerData: twoRatingGiveDeliveryReviewContainerData,
      twoRatingGiveDeliveryReviewContainerSubmitCallback: twoRatingGiveDeliveryReviewContainerSubmitCallback,
      twoRatingGiveDeliveryReviewContainerController: _twoRatingGiveDeliveryReviewContainerController.controller,
      giveDeliveryReviewValueCallback: giveDeliveryReviewValueCallback,
      generalGiveDeliveryReviewContainerParameter: generalGiveDeliveryReviewContainerParameter,
    );
  }
}

class _StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidget extends StatefulWidget {
  final TwoRatingGiveDeliveryReviewContainerController twoRatingGiveDeliveryReviewContainerController;
  final TwoRatingGiveDeliveryReviewContainerData twoRatingGiveDeliveryReviewContainerData;
  final TwoRatingGiveDeliveryReviewContainerSubmitCallback twoRatingGiveDeliveryReviewContainerSubmitCallback;
  final void Function(GiveDeliveryReviewValue?) giveDeliveryReviewValueCallback;
  final GeneralGiveDeliveryReviewContainerParameter generalGiveDeliveryReviewContainerParameter;

  const _StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidget({
    super.key,
    required this.twoRatingGiveDeliveryReviewContainerController,
    required this.twoRatingGiveDeliveryReviewContainerData,
    required this.twoRatingGiveDeliveryReviewContainerSubmitCallback,
    required this.giveDeliveryReviewValueCallback,
    required this.generalGiveDeliveryReviewContainerParameter
  });

  @override
  State<_StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidget> createState() => _StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidgetState();
}

class _StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidgetState extends State<_StatefulTwoRatingGiveDeliveryReviewContainerControllerMediatorWidget> {
  late TextEditingController _feedbackTextEditingController;

  @override
  void initState() {
    super.initState();
    _feedbackTextEditingController = widget.twoRatingGiveDeliveryReviewContainerData._feedbackTextEditingController;
    widget.twoRatingGiveDeliveryReviewContainerSubmitCallback._onSubmit = () => widget.twoRatingGiveDeliveryReviewContainerController.submit();
  }

  @override
  Widget build(BuildContext context) {
    widget.twoRatingGiveDeliveryReviewContainerController.setTwoRatingGiveDeliveryReviewContainerDelegate(
      TwoRatingGiveDeliveryReviewContainerDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetDissatisfiedFeedbackInput: () => _feedbackTextEditingController.text,
        onSubmit: () => widget.giveDeliveryReviewValueCallback(
          TwoRatingGiveDeliveryReviewValue(
            dissatisfiedFeedback: _feedbackTextEditingController.text,
            combinedOrderId: widget.generalGiveDeliveryReviewContainerParameter.combinedOrderId,
            countryId: widget.generalGiveDeliveryReviewContainerParameter.countryId,
            attachmentFilePath: widget.twoRatingGiveDeliveryReviewContainerData._platformFile.map<String>(
              (platformFile) => platformFile.path.toEmptyStringNonNull
            ).toList()
          )
        )
      )
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "What makes you dissatisfied?",
            Constant.textInIdLanguageKey: "Apa yang bikin kamu tidak puas?"
          }).toEmptyStringNonNull,
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 10),
        RxConsumer<Validator>(
          rxValue: widget.twoRatingGiveDeliveryReviewContainerController.dissatisfiedFeedbackValidatorRx,
          onConsumeValue: (context, value) => Field(
            child: (context, validationResult, validator) => ModifiedTextField(
              isError: validationResult.isFailed,
              controller: _feedbackTextEditingController,
              decoration: DefaultInputDecoration(
                hintText: "Come on, tell me your satisfaction about the quality of goods and our service".tr
              ),
              onChanged: (value) => validator?.validate(),
              textInputAction: TextInputAction.next,
              maxLines: 4,
            ),
            validator: value,
          ),
        ),
        const SizedBox(height: 10),
        TapArea(
          onTap: () async {
            FilePickerResult? filePickerResult = await DialogHelper.showChooseFileOrTakePhoto(
              allowMultipleSelectFiles: true
            );
            if (filePickerResult != null) {
              widget.twoRatingGiveDeliveryReviewContainerData._platformFile.addAll(filePickerResult.files);
              setState(() {});
            }
          },
          child: Container(
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ModifiedSvgPicture.asset(
                    Constant.vectorCameraOutline,
                    overrideDefaultColorWithSingleColor: false
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Love to see a photo or video of the item".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey.shade400
            ),
          ),
        ),
        GiveDeliveryReviewAttachmentSection(
          onGetPlatformFileList: () => widget.twoRatingGiveDeliveryReviewContainerData._platformFile,
          onSetState: () => setState(() {})
        )
      ]
    );
  }
}

class TwoRatingGiveDeliveryReviewContainerData {
  final TextEditingController _feedbackTextEditingController;
  final List<PlatformFile> _platformFile = [];

  TwoRatingGiveDeliveryReviewContainerData({
    required TextEditingController feedbackTextEditingController
  }) : _feedbackTextEditingController = feedbackTextEditingController;
}

class TwoRatingGiveDeliveryReviewContainerSubmitCallback extends GiveDeliveryReviewContainerSubmitCallback {
  void Function()? _onSubmit;

  @override
  void Function() get onSubmit => _onSubmit ?? (throw UnimplementedError());
}