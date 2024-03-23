import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/delete_account_modal_dialog_controller.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/send_delete_account_otp_use_case.dart';
import '../../../domain/usecase/verify_delete_account_otp_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/login_helper.dart';
import '../../../misc/main_route_observer.dart';
import '../../../misc/multi_language_string.dart';
import '../../notifier/notification_notifier.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_pin_input.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/something_counter.dart';
import 'modal_dialog_page.dart';

class DeleteAccountModalDialogPage extends ModalDialogPage<DeleteAccountModalDialogController> {
  final void Function() onBackToMainMenu;

  DeleteAccountModalDialogController get deleteAccountModalDialogController => modalDialogController.controller;

  DeleteAccountModalDialogPage({
    super.key,
    required this.onBackToMainMenu
  });

  @override
  DeleteAccountModalDialogController onCreateModalDialogController() {
    return DeleteAccountModalDialogController(
      controllerManager,
      Injector.locator<SendDeleteAccountOtpUseCase>(),
      Injector.locator<VerifyDeleteAccountOtpUseCase>(),
      Injector.locator<GetUserUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulDeleteAccountModalDialogControllerMediatorWidget(
      deleteAccountModalDialogController: deleteAccountModalDialogController,
      onBackToMainMenu: onBackToMainMenu
    );
  }
}

class _StatefulDeleteAccountModalDialogControllerMediatorWidget extends StatefulWidget {
  final DeleteAccountModalDialogController deleteAccountModalDialogController;
  final void Function() onBackToMainMenu;

  const _StatefulDeleteAccountModalDialogControllerMediatorWidget({
    required this.deleteAccountModalDialogController,
    required this.onBackToMainMenu
  });

  @override
  State<_StatefulDeleteAccountModalDialogControllerMediatorWidget> createState() => _StatefulDeleteAccountModalDialogControllerMediatorWidgetState();
}

class _StatefulDeleteAccountModalDialogControllerMediatorWidgetState extends State<_StatefulDeleteAccountModalDialogControllerMediatorWidget> {
  int _step = 1;

  final FocusNode _verificationOtpFocusNode = FocusNode();
  final TextEditingController _verificationOtpTextEditingController = TextEditingController();
  final TapGestureRecognizer _resendVerificationTapGestureRecognizer = TapGestureRecognizer();
  Timer? _resendVerificationCountdownTimer;
  final int _maxCountdownTimerValue = 120;
  int _countdownTimerValue = 0;

  @override
  Widget build(BuildContext context) {
    widget.deleteAccountModalDialogController.setDeleteAccountDelegate(
      DeleteAccountDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onDeleteAccountBack: () => Get.back(),
        onShowSendDeleteAccountOtpRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowSendDeleteAccountOtpRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onSendDeleteAccountOtpRequestProcessSuccessCallback: (sendDeleteAccountOtpResponse) async {
          if (_resendVerificationCountdownTimer != null) {
            _resendVerificationCountdownTimer!.cancel();
          }
          _countdownTimerValue = _maxCountdownTimerValue;
          _resendVerificationCountdownTimer = Timer.periodic(
            const Duration(seconds: 1),
            (timer) {
              setState(() => _countdownTimerValue -= 1);
              if (_countdownTimerValue <= 0) {
                timer.cancel();
              }
            }
          );
          setState(() => _step = 2);
        },
        onShowVerifyDeleteAccountOtpRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowVerifyDeleteAccountOtpRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onVerifyDeleteAccountOtpRequestProcessSuccessCallback: (verifyDeleteAccountOtpResponse) async {
          // Reset reset verification countdown timer to default
          if (_resendVerificationCountdownTimer != null) {
            _resendVerificationCountdownTimer!.cancel();
          }
          _countdownTimerValue = _maxCountdownTimerValue;
          Provider.of<NotificationNotifier>(context, listen: false).resetNotification();
          if (MainRouteObserver.onResetInitMainMenu != null) {
            MainRouteObserver.onResetInitMainMenu!();
          }
          widget.onBackToMainMenu();
        },
        onLogoutIntoOneSignal: () async {
          while (true) {
            try {
              await OneSignal.logout();
              return SuccessLoadDataResult<String>(value: "");
            } catch (e, stackTrace) {
              // If in debug mode then show one signal logout error reason and stack trace
              // Retry logout until success
              if (kDebugMode) {
                print("One signal error: $e");
                print("One signal error stack trace: $stackTrace");
              }
            }
          }
        },
        onUnsubscribeChatCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.unsubscribeChatCount(userId),
        onUnsubscribeNotificationCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.unsubscribeNotificationCount(userId),
        onDeleteToken: () => LoginHelper.deleteToken().future(),
      )
    );
    List<MultiLanguageString> multiLanguageStringList = [
      MultiLanguageString({
        Constant.textInIdLanguageKey: "Jika ada pembayaran yang belum selesai, maka tidak bisa melakukan penghapusan akun.",
        Constant.textEnUsLanguageKey: "If there is an incomplete payment, you cannot delete the account."
      }),
      MultiLanguageString({
        Constant.textInIdLanguageKey: "Setelah akun kamu berhasil dihapus, Master Bagasi akan tetap menyimpan seluruh data transaksi untuk keperluan audit.",
        Constant.textEnUsLanguageKey: "After your account has been successfully deleted, Master Bagasi will continue to store all transaction data for audit purposes."
      })
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Builder(
                builder: (context) {
                  String text = "";
                  if (_step == 1) {
                    text = "Important".tr;
                  } else if (_step == 2) {
                    text = "Verification".tr;
                  }
                  return Text(text);
                }
              )
            ],
          ),
          primary: false,
        ),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Builder(
            builder: (context) {
              if (_step == 1) {
                return Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...multiLanguageStringList.mapIndexed<Widget>((index, value) {
                        Widget result = Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("-"),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                value.toEmptyStringNonNull
                              )
                            )
                          ],
                        );
                        if (index > 0) {
                          return Column(
                            children: [
                              const SizedBox(height: 5.0),
                              result
                            ],
                          );
                        }
                        return result;
                      }).toList(),
                      const SizedBox(height: 16.0),
                      SizedOutlineGradientButton(
                        onPressed: widget.deleteAccountModalDialogController.sendDeleteAccountOtp,
                        text: "Send OTP".tr,
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                      )
                    ]
                  )
                );
              } else if (_step == 2) {
                return Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 4.w),
                  child: Column(
                    children: [
                      Text(
                        MultiLanguageString({
                          Constant.textInIdLanguageKey: "Masukan Kode Verifikasi",
                          Constant.textEnUsLanguageKey: "Enter Verification Code"
                        }).toEmptyStringNonNull,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          // late String type;
                          // if (sendRegisterOtpResponse is EmailSendRegisterOtpResponse) {
                          //   type = "e-mail";
                          // } else if (sendRegisterOtpResponse is WaSendRegisterOtpResponse) {
                          //   type = "WhatsApp";
                          // } else {
                          //   type = MultiLanguageString({
                          //     Constant.textInIdLanguageKey: "(Tidak Diketahui)",
                          //     Constant.textEnUsLanguageKey: "(Unknown)"
                          //   }).toEmptyStringNonNull;
                          // }
                          // return Text(
                          //   MultiLanguageString({
                          //     Constant.textInIdLanguageKey: "Kode verifikasi telah dikirim melalui $type ke ${sendRegisterOtpResponse.credential}",
                          //     Constant.textEnUsLanguageKey: "A verification code has been sent via $type to ${sendRegisterOtpResponse.credential}"
                          //   }).toEmptyStringNonNull,
                          //   textAlign: TextAlign.center,
                          // );
                          return Text(
                            MultiLanguageString({
                              Constant.textInIdLanguageKey: "Kode verifikasi telah dikirim.",
                              Constant.textEnUsLanguageKey: "A verification code has been sent."
                            }).toEmptyStringNonNull,
                            textAlign: TextAlign.center,
                          );
                        }
                      ),
                      const SizedBox(height: 14.0),
                      ModifiedPinInput(
                        focusNode: _verificationOtpFocusNode,
                        textEditingController: _verificationOtpTextEditingController,
                        onCompleted: _onCompleted
                      ),
                      const SizedBox(height: 10.0),
                      Builder(
                        builder: (context) {
                          _resendVerificationTapGestureRecognizer.onTap = widget.deleteAccountModalDialogController.sendDeleteAccountOtp;
                          return Text.rich(
                            TextSpan(
                              children: [
                                if (_countdownTimerValue > 0) ...[
                                  TextSpan(
                                    text: MultiLanguageString({
                                      Constant.textInIdLanguageKey: "Mohon tunggu dalam ",
                                      Constant.textEnUsLanguageKey: "Please wait in "
                                    }).toEmptyStringNonNull
                                  ),
                                  TextSpan(
                                    text: MultiLanguageString({
                                      Constant.textInIdLanguageKey: "$_countdownTimerValue detik",
                                      Constant.textEnUsLanguageKey: "$_countdownTimerValue seconds"
                                    }).toEmptyStringNonNull,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  TextSpan(
                                    text: MultiLanguageString({
                                      Constant.textInIdLanguageKey: " untuk kirim ulang verifikasi",
                                      Constant.textEnUsLanguageKey: " for resend verification"
                                    }).toEmptyStringNonNull
                                  )
                                ] else ...[
                                  TextSpan(
                                    text: MultiLanguageString({
                                      Constant.textInIdLanguageKey: "Kirim Ulang Verifikasi",
                                      Constant.textEnUsLanguageKey: "Resend Verification"
                                    }).toEmptyStringNonNull,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary
                                    ),
                                    recognizer: _resendVerificationTapGestureRecognizer
                                  )
                                ]
                              ]
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      )
                    ],
                  )
                );
              } else {
                return Container();
              }
            }
          ),
        )
      ],
    );
  }

  void _onCompleted(String value) {
    if (_step == 2) {
      widget.deleteAccountModalDialogController.verifyDeleteAccountOtp(value);
    }
  }

  @override
  void dispose() {
    _resendVerificationCountdownTimer?.cancel();
    _verificationOtpTextEditingController.dispose();
    _verificationOtpFocusNode.dispose();
    super.dispose();
  }
}