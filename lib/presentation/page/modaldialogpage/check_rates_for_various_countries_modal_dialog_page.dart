import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/check_rates_for_various_countries_modal_dialog_controller.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/injector.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import 'modal_dialog_page.dart';
import 'select_countries_modal_dialog_page.dart';

class CheckRatesForVariousCountriesModalDialogPage extends ModalDialogPage<CheckRatesForVariousCountriesModalDialogController> {
  CheckRatesForVariousCountriesModalDialogController get checkRatesForVariousCountriesModalDialogController => modalDialogController.controller;

  CheckRatesForVariousCountriesModalDialogPage({
    Key? key,
  }) : super(key: key);

  @override
  CheckRatesForVariousCountriesModalDialogController onCreateModalDialogController() {
    return CheckRatesForVariousCountriesModalDialogController(
      controllerManager,
      Injector.locator<CheckRatesForVariousCountriesUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCheckRatesForVariousCountriesControllerMediatorWidget(
      checkRatesForVariousCountriesModalDialogController: checkRatesForVariousCountriesModalDialogController,
    );
  }
}

class _StatefulCheckRatesForVariousCountriesControllerMediatorWidget extends StatefulWidget {
  final CheckRatesForVariousCountriesModalDialogController checkRatesForVariousCountriesModalDialogController;

  const _StatefulCheckRatesForVariousCountriesControllerMediatorWidget({
    required this.checkRatesForVariousCountriesModalDialogController
  });

  @override
  State<_StatefulCheckRatesForVariousCountriesControllerMediatorWidget> createState() => _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState();
}

class _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState extends State<_StatefulCheckRatesForVariousCountriesControllerMediatorWidget> {
  Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    TextStyle getDefaultTextStyle() {
      return TextStyle(
        color: Constant.colorDarkBlue,
        fontWeight: FontWeight.bold
      );
    }
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Our shipping price list".tr),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: SizedOutlineGradientButton(
              onPressed: () {
                DialogHelper.showModalDialogPage<Country, Country>(
                  context: context,
                  modalDialogPageBuilder: (context, parameter) => SelectCountriesModalDialogPage(
                    selectedCountry: parameter,
                  ),
                  parameter: _selectedCountry,
                );
              },
              child: _selectedCountry == null ? Text(
                "(${"Not Selected".tr})",
                style: getDefaultTextStyle()
              ) : Row(
                children: [
                  Text(
                    _selectedCountry!.name,
                    style: getDefaultTextStyle()
                  )
                ]
              ),
              text: "",
              outlineGradientButtonType: OutlineGradientButtonType.outline,
              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
              customGradientButtonVariation: (outlineGradientButtonType) {
                return CustomGradientButtonVariation(
                  outlineGradientButtonType: outlineGradientButtonType,
                  gradient: Constant.buttonGradient2,
                  backgroundColor: Colors.white,
                  textStyle: getDefaultTextStyle()
                );
              },
              customPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            ),
          ),
        ]
      )
    );
  }
}