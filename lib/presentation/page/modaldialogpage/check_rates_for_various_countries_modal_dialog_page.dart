import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/check_rates_for_various_countries_modal_dialog_controller.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/entity/cargo/cargo.dart';
import '../../../domain/entity/delivery/country_based_country_code_parameter.dart';
import '../../../domain/entity/delivery/country_delivery_review_response.dart';
import '../../../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../../../domain/usecase/get_country_based_country_code.dart';
import '../../../domain/usecase/get_country_delivery_review_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../../widget/rx_consumer.dart';
import '../../widget/select_country_indicator.dart';
import 'modal_dialog_page.dart';

class CheckRatesForVariousCountriesModalDialogPage extends ModalDialogPage<CheckRatesForVariousCountriesModalDialogController> {
  CheckRatesForVariousCountriesModalDialogController get checkRatesForVariousCountriesModalDialogController => modalDialogController.controller;

  final CheckRatesForVariousCountriesModalDialogPageParameter checkRatesForVariousCountriesModalDialogPageParameter;

  CheckRatesForVariousCountriesModalDialogPage({
    Key? key,
    required this.checkRatesForVariousCountriesModalDialogPageParameter
  }) : super(key: key);

  @override
  CheckRatesForVariousCountriesModalDialogController onCreateModalDialogController() {
    return CheckRatesForVariousCountriesModalDialogController(
      controllerManager,
      Injector.locator<CheckRatesForVariousCountriesUseCase>(),
      Injector.locator<GetCountryDeliveryReviewUseCase>(),
      Injector.locator<GetCountryBasedCountryCodeUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCheckRatesForVariousCountriesControllerMediatorWidget(
      checkRatesForVariousCountriesModalDialogController: checkRatesForVariousCountriesModalDialogController,
      checkRatesForVariousCountriesModalDialogPageParameter: checkRatesForVariousCountriesModalDialogPageParameter
    );
  }
}

class _StatefulCheckRatesForVariousCountriesControllerMediatorWidget extends StatefulWidget {
  final CheckRatesForVariousCountriesModalDialogController checkRatesForVariousCountriesModalDialogController;
  final CheckRatesForVariousCountriesModalDialogPageParameter checkRatesForVariousCountriesModalDialogPageParameter;

  const _StatefulCheckRatesForVariousCountriesControllerMediatorWidget({
    required this.checkRatesForVariousCountriesModalDialogController,
    required this.checkRatesForVariousCountriesModalDialogPageParameter,
  });

  @override
  State<_StatefulCheckRatesForVariousCountriesControllerMediatorWidget> createState() => _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState();
}

class _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState extends State<_StatefulCheckRatesForVariousCountriesControllerMediatorWidget> {
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    String? countryCode = widget.checkRatesForVariousCountriesModalDialogPageParameter.countryCode;
    if (countryCode.isNotEmptyString) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.checkRatesForVariousCountriesModalDialogController.getCountryBasedCountryCode(
          CountryBasedCountryCodeParameter(
            countryCode: countryCode!
          )
        );
      });
    }
  }

  void _loadCargoAndCountryDeliveryReview() {
    widget.checkRatesForVariousCountriesModalDialogController.loadCargo();
    widget.checkRatesForVariousCountriesModalDialogController.loadCountryDeliveryReview();
  }

  @override
  Widget build(BuildContext context) {
    widget.checkRatesForVariousCountriesModalDialogController.setCartDelegate(
      CartDelegate(
        onGetSelectedCountry: () => _selectedCountry,
        onCheckRatesForVariousCountriesBack: () => Get.back(),
        onShowGetCountryBasedCountryCodeProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onGetCountryBasedCountryCodeProcessSuccessCallback: (countryBasedCountryCodeResponse) async {
          setState(() => _selectedCountry = countryBasedCountryCodeResponse.country);
          _loadCargoAndCountryDeliveryReview();
        },
        onShowGetCountryBasedCountryCodeProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e,
            onPressed: () => Get.back(result: true)
          );
        },
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
          SelectCountryIndicator(
            selectedCountry: _selectedCountry,
            onSelectCountry: (country) {
              setState(() => _selectedCountry = country);
              _loadCargoAndCountryDeliveryReview();
            }
          ),
          RxConsumer<CheckRatesForVariousCountriesResult>(
            rxValue: widget.checkRatesForVariousCountriesModalDialogController.checkRatesForVariousCountriesResultRx,
            onConsumeValue: (context, value) => Column(
              children: [
                ...[
                  if (!value.cargoLoadDataResult.isNotLoading) const SizedBox(height: 5),
                  LoadDataResultImplementer<CountryDeliveryReviewResponse>(
                    loadDataResult: value.countryDeliveryReviewLoadDataResult,
                    errorProvider: Injector.locator<ErrorProvider>(),
                    onSuccessLoadDataResultWidget: (countryDeliveryReviewResponse) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: FittedBox(
                              child: Image.asset(Constant.imageStar),
                            )
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${countryDeliveryReviewResponse.avgRating}",
                            style: const TextStyle(
                              height: 2,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                  if (!value.cargoLoadDataResult.isNotLoading) const SizedBox(height: 10),
                  LoadDataResultImplementer<List<Cargo>>(
                    loadDataResult: value.cargoLoadDataResult,
                    errorProvider: Injector.locator<ErrorProvider>(),
                    onSuccessLoadDataResultWidget: (cargoList) {
                      EdgeInsetsGeometry cellPadding = const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0);
                      EdgeInsetsGeometry cellHeaderPadding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0);
                      return Column(
                        children: [
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
                          const SizedBox(height: 8),
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.7),
                              1: FlexColumnWidth(0.7),
                              2: FlexColumnWidth(),
                              3: FlexColumnWidth()
                            },
                            children: [
                              TableRow(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: cellHeaderPadding,
                                      child: Text(
                                        "${"Weight".tr} (${"Min".tr})",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: cellHeaderPadding,
                                      child: Text(
                                        "${"Weight".tr} (${"Max".tr})",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: cellHeaderPadding,
                                      child: Text(
                                        "Price Individual".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: cellHeaderPadding,
                                      child: Text(
                                        "Price Together".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ),
                                ]
                              ),
                              ...cargoList.mapIndexed<TableRow>(
                                (index, cargo) {
                                  Widget firstLine(Color color) {
                                    return Container(
                                      height: 2,
                                      color: color
                                    );
                                  }
                                  Widget kgText(double kgValue) {
                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: kgValue.toDecimalStringIfHasDecimalValue(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
                                          ),
                                          const WidgetSpan(child: SizedBox(width: 0.6)),
                                          const TextSpan(
                                            text: "Kg",
                                            style: TextStyle(
                                              fontSize: 9
                                            )
                                          )
                                        ]
                                      )
                                    );
                                  }
                                  Widget rupiahText(int rupiahValue) {
                                    String rupiahTextResult = rupiahValue.toRupiah();
                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Rp",
                                            style: TextStyle(
                                              fontSize: 9
                                            )
                                          ),
                                          const WidgetSpan(child: SizedBox(width: 0.6)),
                                          TextSpan(
                                            text: rupiahTextResult.substring(2, rupiahTextResult.length),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12
                                            )
                                          ),
                                        ]
                                      )
                                    );
                                  }
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color: (index + 1) % 2 != 0 ? Colors.grey.shade200 : null,
                                    ),
                                    children: [
                                      Center(
                                        child: Column(
                                          children: [
                                            if (index == 0) firstLine(Constant.colorButtonGradient3),
                                            Padding(
                                              padding: cellPadding,
                                              child: kgText(cargo.minWeight)
                                            ),
                                          ],
                                        )
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            if (index == 0) firstLine(Constant.colorButtonGradient1),
                                            Padding(
                                              padding: cellPadding,
                                              child: kgText(cargo.maxWeight)
                                            ),
                                          ],
                                        )
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            if (index == 0) firstLine(Constant.colorButtonGradient2),
                                            Padding(
                                              padding: cellPadding,
                                              child: rupiahText(cargo.price),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            if (index == 0) firstLine(Constant.colorButtonGradient3),
                                            Padding(
                                              padding: cellPadding,
                                              child: rupiahText(cargo.priceTogether),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                  );
                                }
                              ).toList()
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedOutlineGradientButton(
                            onPressed: () {
                              if (_selectedCountry != null) {
                                widget.checkRatesForVariousCountriesModalDialogPageParameter.onGotoCountryDeliveryReview(_selectedCountry!.id);
                              }
                            },
                            text: "Delivery Review".tr,
                            outlineGradientButtonType: OutlineGradientButtonType.solid,
                            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                            customPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                          ),
                        ],
                      );
                    }
                  ),
                ]
              ],
            )
          )
        ]
      )
    );
  }
}

class CheckRatesForVariousCountriesModalDialogPageParameter {
  String? countryCode;
  void Function(String) onGotoCountryDeliveryReview;

  CheckRatesForVariousCountriesModalDialogPageParameter({
    this.countryCode,
    required this.onGotoCountryDeliveryReview
  });
}