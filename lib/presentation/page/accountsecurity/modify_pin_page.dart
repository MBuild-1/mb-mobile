import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/domain/entity/pin/modifypin/modifypinparameter/create_modify_pin_parameter.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/accountsecuritycontroller/modify_pin_controller.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/change_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/remove_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/validate_modify_pin_parameter.dart';
import '../../../domain/usecase/modify_pin_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/string_util.dart';
import '../../../misc/toast_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_svg_picture.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../getx_page.dart';

class ModifyPinPage extends RestorableGetxPage<_ModifyPinPageRestoration> {
  late final ControllerMember<ModifyPinController> _modifyPinController = ControllerMember<ModifyPinController>().addToControllerManager(controllerManager);

  final ModifyPinPageParameter modifyPinPageParameter;

  ModifyPinPage({
    Key? key,
    required this.modifyPinPageParameter
  }) : super(key: key, pageRestorationId: () => "modify-pin-page");

  @override
  void onSetController() {
    _modifyPinController.controller = GetExtended.put<ModifyPinController>(
      ModifyPinController(
        controllerManager,
        Injector.locator<ModifyPinUseCase>()
      ), tag: pageName
    );
  }

  @override
  _ModifyPinPageRestoration createPageRestoration() => _ModifyPinPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulModifyPinControllerMediatorWidget(
        modifyPinController: _modifyPinController.controller,
        modifyPinPageParameter: modifyPinPageParameter,
      ),
    );
  }
}

class _ModifyPinPageRestoration extends MixableGetxPageRestoration {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class ModifyPinPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ModifyPinPageParameter modifyPinPageParameter;

  ModifyPinPageGetPageBuilderAssistant({
    required this.modifyPinPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ModifyPinPage(modifyPinPageParameter: modifyPinPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ModifyPinPage(modifyPinPageParameter: modifyPinPageParameter)));
}

mixin ModifyPinPageRestorationMixin on MixableGetxPageRestoration {
  late ModifyPinPageRestorableRouteFuture modifyPinPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    modifyPinPageRestorableRouteFuture = ModifyPinPageRestorableRouteFuture(restorationId: restorationIdWithPageName('modify-pin-page-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    modifyPinPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    modifyPinPageRestorableRouteFuture.dispose();
  }
}

class ModifyPinPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ModifyPinPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    ModifyPinPageParameter modifyPinPageParameter = arguments.toModifyPinPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ModifyPinPageGetPageBuilderAssistant(
          modifyPinPageParameter: modifyPinPageParameter
        )
      )
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulModifyPinControllerMediatorWidget extends StatefulWidget {
  final ModifyPinController modifyPinController;
  final ModifyPinPageParameter modifyPinPageParameter;

  const _StatefulModifyPinControllerMediatorWidget({
    required this.modifyPinController,
    required this.modifyPinPageParameter
  });

  @override
  State<_StatefulModifyPinControllerMediatorWidget> createState() => _StatefulModifyPinControllerMediatorWidgetState();
}

class _StatefulModifyPinControllerMediatorWidgetState extends State<_StatefulModifyPinControllerMediatorWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  int _step = 1;
  late ModifyPinParameter _modifyPinParameter;

  @override
  void initState() {
    super.initState();
    ModifyPinType modifyPinType = widget.modifyPinPageParameter.modifyPinType;
    if (modifyPinType == ModifyPinType.createPin) {
      _modifyPinParameter = CreateModifyPinParameter(
        pin: "",
        confirmPin: ""
      );
    } else if (modifyPinType == ModifyPinType.changePin) {
      _modifyPinParameter = ChangeModifyPinParameter(
        currentPin: "",
        newPin: "",
        confirmNewPin: ""
      );
    } else if (modifyPinType == ModifyPinType.removePin) {
      _modifyPinParameter = RemoveModifyPinParameter(
        pin: "",
      );
    } else if (modifyPinType == ModifyPinType.validatePin) {
      _modifyPinParameter = ValidateModifyPinParameter(
        pin: "",
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.modifyPinController.setModifyPinDelegate(
      ModifyPinDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetModifyPinParameterInput: () => _modifyPinParameter,
        onModifyPinBack: () => Get.back(),
        onShowModifyPinRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowModifyPinRequestProcessFailedCallback: (e) async {
          ErrorProviderResult errorProviderResult = Injector.locator<ErrorProvider>().onGetErrorProviderResult(e).toErrorProviderResultNonNull();
          ToastHelper.showToast(errorProviderResult.message);
        },
        onModifyPinRequestProcessSuccessCallback: () async {
          Get.back();
          ToastHelper.showToast("${"Success change password".tr}.");
        }
      )
    );
    String title = "";
    String description = "";
    if (_modifyPinParameter is CreateModifyPinParameter) {
      if (_step == 1) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "New PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter New PIN Master Bagasi"
        }).toEmptyStringNonNull;
      } else if (_step == 2) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "Konfirmasi PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Confirm New PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan Konfirmasi PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter Confirm New PIN Master Bagasi"
        }).toEmptyStringNonNull;
      }
    } else if (_modifyPinParameter is ChangeModifyPinParameter) {
      if (_step == 1) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "PIN Saat Ini Master Bagasi",
          Constant.textEnUsLanguageKey: "Current PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan PIN Saat Ini Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter Current PIN Master Bagasi"
        }).toEmptyStringNonNull;
      } else if (_step == 2) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "New PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter New PIN Master Bagasi"
        }).toEmptyStringNonNull;
      } else if (_step == 3) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "Konfirmasi PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Confirm New PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan Konfirmasi PIN Baru Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter Confirm New PIN Master Bagasi"
        }).toEmptyStringNonNull;
      }
    } else if (_modifyPinParameter is RemoveModifyPinParameter || _modifyPinParameter is ValidateModifyPinParameter) {
      if (_step == 1) {
        title = MultiLanguageString({
          Constant.textInIdLanguageKey: "PIN Master Bagasi",
          Constant.textEnUsLanguageKey: "PIN Master Bagasi"
        }).toEmptyStringNonNull;
        description = MultiLanguageString({
          Constant.textInIdLanguageKey: "Masukan PIN Master Bagasi",
          Constant.textEnUsLanguageKey: "Enter PIN Master Bagasi"
        }).toEmptyStringNonNull;
      }
    }
    if (_errorText != null) {
      description = _errorText!;
    }
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Expanded(
              child: title ?? Container()
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ModifiedSvgPicture.asset(
                      Constant.vectorPinLock,
                      overrideDefaultColorWithSingleColor: false
                    ),
                    const SizedBox(height: 30),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        color: _errorText != null ? Constant.colorRedDanger : null
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 180,
                      child: PinCodeTextField(
                        focusNode: _focusNode,
                        appContext: context,
                        length: 6,
                        obscureText: true,
                        animationType: AnimationType.none,
                        pinTheme: PinTheme(
                          selectedColor: Constant.colorMain,
                          activeColor: Constant.colorMain,
                          inactiveColor: Constant.colorMain,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 30,
                          activeFillColor: Colors.black,
                        ),
                        animationDuration: const Duration(milliseconds: 0),
                        enableActiveFill: false,
                        controller: _textEditingController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        hintCharacter: '●',
                        autoDisposeControllers: false,
                        autoFocus: false,
                        autoUnfocus: false,
                        onCompleted: _onCompleted,
                        beforeTextPaste: (text) {
                          return false;
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      "Hindari menggunakan kombinasi angka yang mudah ditebak, seperti tanggal lahir atau nomor telepon.",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Constant.colorGrey7
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }

  void _onCompleted(String value) {
    void errorConfirmationPin() async {
      _focusNode.requestFocus();
      _errorText = MultiLanguageString({
        Constant.textInIdLanguageKey: "Konfirmasi PIN yang anda masukan tidak sesuai dengan PIN yang dimasukan.",
        Constant.textEnUsLanguageKey: "Confirm that the PIN you entered does not match the PIN entered."
      }).toEmptyStringNonNull;
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));
      _errorText = null;
      setState(() {});
    }
    if (_modifyPinParameter is CreateModifyPinParameter) {
      CreateModifyPinParameter createModifyPinParameter = _modifyPinParameter as CreateModifyPinParameter;
      if (_step == 1) {
        createModifyPinParameter.pin = _textEditingController.text;
        _textEditingController.clear();
        _step += 1;
        _focusNode.requestFocus();
        setState(() {});
      } else if (_step == 2) {
        createModifyPinParameter.confirmPin = _textEditingController.text;
        _textEditingController.clear();
        if (createModifyPinParameter.pin != createModifyPinParameter.confirmPin) {
          _step = 2;
          setState(() {});
          errorConfirmationPin();
        } else {
          widget.modifyPinController.modifyPin();
        }
      }
    } else if (_modifyPinParameter is ChangeModifyPinParameter) {
      ChangeModifyPinParameter changeModifyPinParameter = _modifyPinParameter as ChangeModifyPinParameter;
      if (_step == 1) {
        changeModifyPinParameter.currentPin = _textEditingController.text;
        _textEditingController.clear();
        _step += 1;
        _focusNode.requestFocus();
        setState(() {});
      } else if (_step == 2) {
        changeModifyPinParameter.newPin = _textEditingController.text;
        _textEditingController.clear();
        _step += 1;
        _focusNode.requestFocus();
      } else if (_step == 3) {
        changeModifyPinParameter.confirmNewPin = _textEditingController.text;
        _textEditingController.clear();
        if (changeModifyPinParameter.newPin != changeModifyPinParameter.confirmNewPin) {
          _step = 2;
          setState(() {});
          errorConfirmationPin();
        } else {
          widget.modifyPinController.modifyPin();
        }
      }
    } else if (_modifyPinParameter is RemoveModifyPinParameter) {
      RemoveModifyPinParameter removeModifyPinParameter = _modifyPinParameter as RemoveModifyPinParameter;
      if (_step == 1) {
        removeModifyPinParameter.pin = _textEditingController.text;
        _textEditingController.clear();
        widget.modifyPinController.modifyPin();
      }
    } else if (_modifyPinParameter is ValidateModifyPinParameter) {
      RemoveModifyPinParameter removeModifyPinParameter = _modifyPinParameter as RemoveModifyPinParameter;
      if (_step == 1) {
        removeModifyPinParameter.pin = _textEditingController.text;
        _textEditingController.clear();
        widget.modifyPinController.modifyPin();
      }
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

enum ModifyPinType {
  createPin, changePin, removePin, validatePin
}

class ModifyPinPageParameter {
  ModifyPinType modifyPinType;

  ModifyPinPageParameter({
    required this.modifyPinType
  });
}

extension ModifyPinPageParameterExt on ModifyPinPageParameter {
  String toEncodeBase64String() {
    String result = "";
    if (modifyPinType == ModifyPinType.createPin) {
      result = "1";
    } else if (modifyPinType == ModifyPinType.changePin) {
      result = "2";
    } else if (modifyPinType == ModifyPinType.removePin) {
      result = "3";
    } else if (modifyPinType == ModifyPinType.validatePin) {
      result = "4";
    }
    return StringUtil.encodeBase64StringFromJson(
      <String, dynamic>{
        "modify_pin_type": result
      }
    );
  }
}

extension ModifyPinPageParameterStringExt on String {
  ModifyPinPageParameter toModifyPinPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    dynamic rawModifyPinType = result["modify_pin_type"];
    late ModifyPinType modifyPinType;
    if (rawModifyPinType == "1") {
      modifyPinType = ModifyPinType.createPin;
    } else if (rawModifyPinType == "2") {
      modifyPinType = ModifyPinType.changePin;
    } else if (rawModifyPinType == "3") {
      modifyPinType = ModifyPinType.removePin;
    } else if (rawModifyPinType == "4") {
      modifyPinType = ModifyPinType.validatePin;
    }
    return ModifyPinPageParameter(
      modifyPinType: modifyPinType
    );
  }
}