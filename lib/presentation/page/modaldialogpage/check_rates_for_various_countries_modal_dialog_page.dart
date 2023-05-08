import 'package:collection/collection.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/check_rates_for_various_countries_modal_dialog_controller.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/entity/cargo/cargo.dart';
import '../../../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../../widget/rx_consumer.dart';
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
    widget.checkRatesForVariousCountriesModalDialogController.setCartDelegate(
      CartDelegate(
        onGetSelectedCountry: () => _selectedCountry
      )
    );
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
              onPressed: () async {
                dynamic result = await DialogHelper.showModalDialogPage<Country, Country>(
                  context: context,
                  modalDialogPageBuilder: (context, parameter) => SelectCountriesModalDialogPage(
                    selectedCountry: parameter,
                  ),
                  parameter: _selectedCountry,
                );
                if (result is Country) {
                  setState(() {
                    _selectedCountry = result;
                  });
                  widget.checkRatesForVariousCountriesModalDialogController.loadCargo();
                }
              },
              child: _selectedCountry == null ? Text(
                "(${"Not Selected".tr})",
                style: getDefaultTextStyle()
              ) : Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 12,
                    child: Flag.fromString(_selectedCountry!.code),
                  ),
                  const SizedBox(width: 10),
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
          RxConsumer<LoadDataResultWrapper<List<Cargo>>>(
            rxValue: widget.checkRatesForVariousCountriesModalDialogController.cargoLoadDataResultWrapperRx,
            onConsumeValue: (context, value) => LoadDataResultImplementer<List<Cargo>>(
              loadDataResult: value.loadDataResult,
              errorProvider: Injector.locator<ErrorProvider>(),
              onSuccessLoadDataResultWidget: (cargoList) {
                EdgeInsetsGeometry cellPadding = const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0);
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                        color: Colors.grey
                      ),
                      child: Center(
                        child: Text(
                          "The price of air delivery is listed /Kg".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      )
                    ),
                    const SizedBox(height: 10),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Center(
                              child: Padding(
                                padding: cellPadding,
                                child: Text(
                                  "${"Weight".tr} (${"Min".tr})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              )
                            ),
                            Center(
                              child: Padding(
                                padding: cellPadding,
                                child: Text(
                                  "${"Weight".tr} (${"Max".tr})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              )
                            ),
                            Center(
                              child: Padding(
                                padding: cellPadding,
                                child: Text(
                                  "Price".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              )
                            ),
                          ]
                        ),
                        ...cargoList.mapIndexed<TableRow>(
                          (index, cargo) => TableRow(
                            decoration: BoxDecoration(
                              color: (index + 1) % 2 != 0 ? Colors.grey.shade200 : null,
                            ),
                            children: [
                              Center(
                                child: Padding(
                                  padding: cellPadding,
                                  child: Text(
                                    "${cargo.minWeight} Kg",
                                    style: TextStyle()
                                  ),
                                )
                              ),
                              Center(
                                child: Padding(
                                  padding: cellPadding,
                                  child: Text(
                                    "${cargo.maxWeight} Kg",
                                    style: TextStyle()
                                  ),
                                )
                              ),
                              Center(
                                child: Padding(
                                  padding: cellPadding,
                                  child: Text(
                                    cargo.price.toRupiah(),
                                    style: TextStyle()
                                  ),
                                ),
                              ),
                            ]
                          )
                        ).toList()
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedOutlineGradientButton(
                      onPressed: () {},
                      text: "Delivery Shipping".tr,
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                      customPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    ),
                  ],
                );
              }
            )
          )
        ]
      )
    );
  }
}