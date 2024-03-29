import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterbagasi/misc/ext/get_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../controller/crop_picture_controller.dart';
import '../domain/entity/address/address.dart';
import '../domain/entity/product/productbrand/product_brand.dart';
import '../presentation/page/getx_page.dart';
import '../presentation/page/modaldialogpage/add_host_cart_modal_dialog_page.dart';
import '../presentation/page/modaldialogpage/modal_dialog_page.dart';
import '../presentation/page/modaldialogpage/take_friend_cart_modal_dialog_page.dart';
import '../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../presentation/widget/modified_divider.dart';
import '../presentation/widget/modified_loading_indicator.dart';
import '../presentation/widget/modified_svg_picture.dart';
import '../presentation/widget/modifiedappbar/modified_app_bar.dart';
import '../presentation/widget/modifiedcachednetworkimage/modified_cached_network_image.dart';
import '../presentation/widget/profile_menu_item.dart';
import 'constant.dart';
import 'device_helper.dart';
import 'errorprovider/error_provider.dart';
import 'multi_language_string.dart';
import 'page_restoration_helper.dart';
import 'typedef.dart';
import 'widget_helper.dart';

typedef WidgetBuilderWithPromptCallback = Widget Function(BuildContext context, VoidCallbackWithBuildContextParameter? callback);

typedef ModalDialogPageBuilder<T extends ModalDialogPage, P> = T Function(
  BuildContext context,
  P? parameter
);

class _DialogHelperImpl {
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Loading..."),
                    SizedBox(
                      height: 12.0,
                    ),
                    ModifiedLoadingIndicator()
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void showPromptYesNoDialog({
    required BuildContext context,
    required WidgetBuilder prompt,
    bool canBack = true,
    WidgetBuilderWithPromptCallback? yesPromptButton,
    WidgetBuilderWithPromptCallback? noPromptButton,
    VoidCallbackWithBuildContextParameter? onYesPromptButtonTap,
    VoidCallbackWithBuildContextParameter? onNoPromptButtonTap,
  }) {
    showDialog(
      context: context,
      barrierDismissible: canBack,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => canBack,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prompt(context),
                    const SizedBox(height: 12.0),
                    Builder(
                      builder: (BuildContext context) {
                        Widget buildDefaultYesPromptButtonWidget(Widget textWidget) {
                          return SizedBox(
                            child: TextButton(
                              onPressed: onYesPromptButtonTap != null ? () => onYesPromptButtonTap(context) : null,
                              child: textWidget,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap
                              ),
                            )
                          );
                        }
                        Widget buildDefaultNoPromptButtonWidget(Widget textWidget) {
                          return SizedBox(
                            child: TextButton(
                              onPressed: onNoPromptButtonTap != null ? () => onNoPromptButtonTap(context) : null,
                              child: textWidget,
                              style:
                              TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)
                                ),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            )
                          );
                        }
                        Widget? yesPromptButtonWidget = yesPromptButton != null ? yesPromptButton(context, onYesPromptButtonTap) : null;
                        Widget? noPromptButtonWidget = noPromptButton != null ? noPromptButton(context, onNoPromptButtonTap) : null;
                        if (yesPromptButtonWidget is Text) {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(yesPromptButtonWidget);
                        } else {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(Text("Yes".tr));
                        }
                        if (noPromptButtonWidget is Text) {
                          noPromptButtonWidget = buildDefaultNoPromptButtonWidget(noPromptButtonWidget);
                        } else {
                          noPromptButtonWidget = buildDefaultNoPromptButtonWidget(Text("No".tr));
                        }
                        return Row(
                          children: [
                            Expanded(child: noPromptButtonWidget),
                            SizedBox(width: 2.w),
                            Expanded(child: yesPromptButtonWidget),
                          ]
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void showPromptOkDialog({
    required BuildContext context,
    required WidgetBuilder prompt,
    WidgetBuilderWithPromptCallback? okPromptButton,
    VoidCallbackWithBuildContextParameter? onOkPromptButtonTap,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prompt(context),
                    const SizedBox(height: 12.0),
                    Builder(
                      builder: (BuildContext context) {
                        Widget buildDefaultYesPromptButtonWidget(Widget textWidget) {
                          return SizedBox(
                            child: TextButton(
                              onPressed: onOkPromptButtonTap != null ? () => onOkPromptButtonTap(context) : null,
                              child: textWidget,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap
                              ),
                            )
                          );
                        }
                        Widget? yesPromptButtonWidget = okPromptButton != null ? okPromptButton(context, onOkPromptButtonTap) : null;
                        if (yesPromptButtonWidget is Text) {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(yesPromptButtonWidget);
                        } else {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(Text("OK".tr));
                        }
                        return Row(
                          children: [
                            Expanded(child: yesPromptButtonWidget),
                          ]
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void showSharedCartOptionsPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: Builder(
              builder: (builderContext) {
                Widget beHostDescription(bool withColor, bool withText) => Container(
                  width: double.infinity,
                  child: Visibility(
                    visible: withText,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Text(
                      MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Get a great price by inviting your friends to shop in your cart.",
                        Constant.textInIdLanguageKey: "Dapatkan harga murah dengan mengundang temanmu belanja di keranjang kamu.",
                      }).toEmptyStringNonNull,
                      style: const TextStyle(
                        fontSize: 12.0
                      )
                    )
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: withColor ? Constant.colorBlueGray : null
                  ),
                );
                Widget descriptionContainerBackground() {
                  return Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Constant.colorBlueGray
                      ),
                    ),
                  );
                }
                Widget takeShoppingDescription(bool withColor, bool withText) => Container(
                  width: double.infinity,
                  child: Visibility(
                    visible: withText,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Text(
                      MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Get a great price by joining your friend's cart.",
                        Constant.textInIdLanguageKey: "Dapatkan harga murah dengan bergabung di keranjang teman kamu.",
                      }).toEmptyStringNonNull,
                      style: const TextStyle(
                        fontSize: 12.0
                      )
                    )
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: withColor ? Constant.colorBlueGray : null
                  ),
                );
                Widget descriptionStackGroup = Stack(
                  children: [
                    takeShoppingDescription(false, false),
                    beHostDescription(false, false)
                  ],
                );
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ModifiedSvgPicture.asset(
                                    height: 100,
                                    Constant.vectorBag,
                                    overrideDefaultColorWithSingleColor: false
                                  ),
                                  const SizedBox(height: 10),
                                  SizedOutlineGradientButton(
                                    onPressed: () async {
                                      dynamic result = await DialogHelper.showModalDialogPage<bool, String>(
                                        context: context,
                                        modalDialogPageBuilder: (context, parameter) => AddHostCartModalDialogPage(),
                                      );
                                      if (result != null) {
                                        if (result) {
                                          Navigator.of(context).pop();
                                          PageRestorationHelper.toSharedCartPage(context);
                                        }
                                      }
                                    },
                                    text: "Be The Host".tr,
                                    outlineGradientButtonType: OutlineGradientButtonType.outline,
                                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                                  ),
                                  const SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible: false,
                                        maintainState: true,
                                        maintainAnimation: true,
                                        maintainSize: true,
                                        child: descriptionStackGroup
                                      ),
                                      descriptionContainerBackground(),
                                      beHostDescription(false, true),
                                    ],
                                  )
                                ]
                              )
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Column(
                                children: [
                                  ModifiedSvgPicture.asset(
                                    height: 100,
                                    Constant.vectorBagBlack,
                                    overrideDefaultColorWithSingleColor: false
                                  ),
                                  const SizedBox(height: 10),
                                  SizedOutlineGradientButton(
                                    onPressed: () async {
                                      dynamic result = await DialogHelper.showModalDialogPage<bool, String>(
                                        context: context,
                                        modalDialogPageBuilder: (context, parameter) => TakeFriendCartModalDialogPage(),
                                      );
                                      if (result != null) {
                                        if (result) {
                                          Navigator.of(context).pop();
                                          showRequestJoinBucketIsSuccess(context);
                                        }
                                      }
                                    },
                                    text: "Take Shopping".tr,
                                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                  ),
                                  const SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible: false,
                                        maintainState: true,
                                        maintainAnimation: true,
                                        maintainSize: true,
                                        child: descriptionStackGroup
                                      ),
                                      descriptionContainerBackground(),
                                      takeShoppingDescription(false, true)
                                    ]
                                  )
                                ]
                              )
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );
  }

  void showPromptLogout(BuildContext context, void Function() logout) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Logout".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure to logout?",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin logout?"
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onYesPromptButtonTap: (_) async {
        Get.back();
        logout();
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptConfirmArrived(BuildContext context, void Function() confirmArrived) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Confirm Arrived".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure to confirm arrived?",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin konfirmasi sampai?"
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onYesPromptButtonTap: (_) async {
        Get.back();
        confirmArrived();
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptCancelRegister(BuildContext context, void Function() cancelRegister) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Cancel Register".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure you want to cancel your registration? If you want to register again, you have to start from the beginning again.",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin membatalkan pendaftaran? Jika ingin melakukan pendaftaran lagi, harus dimulai dari awal lagi langkahnya."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onYesPromptButtonTap: (_) async {
        Get.back();
        cancelRegister();
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptCancelChange(BuildContext context, void Function() cancelRegister) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Cancel Change".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure you want to cancel your change? If you want to change again, you have to start from the beginning again.",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin membatalkan perubahan? Jika ingin melakukan perubahan lagi, harus dimulai dari awal lagi langkahnya."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onYesPromptButtonTap: (_) async {
        Get.back();
        cancelRegister();
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptCancelResetPassword(BuildContext context, void Function() cancelRegister) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Cancel Reset Password".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure you want to cancel your reset password? If you want to reset password again, you have to start from the beginning again.",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin membatalkan atur ulang kata sandi? Jika ingin melakukan atur ulang kata sandi lagi, harus dimulai dari awal lagi langkahnya."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onYesPromptButtonTap: (_) async {
        Get.back();
        cancelRegister();
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptUnderConstruction(BuildContext context) {
    DialogHelper.showPromptOkDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text("Feature Coming Soon".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text("${"We apologize for the inconvenience caused".tr}.\r\n${"We're almost done".tr}.", textAlign: TextAlign.center),
          const SizedBox(height: 4),
        ]
      ),
      onOkPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showPromptAppMustBeUpdated(BuildContext context) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      canBack: false,
      prompt: (context) => Column(
        children: [
          Text("Application Must Be Updated".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Because there are very important things that need to be updated, so this application must be updated now.",
              Constant.textInIdLanguageKey: "Dikarenakan ada hal yang sangat penting yang harus diupdate, jadinya aplikasi ini harus diupdate sekarang."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      yesPromptButton: (context, action) {
        return Text("Update Application".tr);
      },
      noPromptButton: (context, action) {
        return Text("Exit From Application".tr);
      },
      onYesPromptButtonTap: (_) async {
        DeviceHelper.updateApplication();
      },
      onNoPromptButtonTap: (_) async {
        if (Platform.isIOS) {
          FlutterExitApp.exitApp(iosForceExit: true);
        } else {
          FlutterExitApp.exitApp();
        }
      },
    );
  }

  void showWaitingRequestJoinBucketIsAccepted(BuildContext context) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Your Request Has Not Been Accepted By The Host",
              Constant.textInIdLanguageKey: "Request Anda Belum Diterima Oleh Host"
            }).toEmptyStringNonNull,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "For now, your Request Has Not Been Accepted By The Host. Please wait.",
              Constant.textInIdLanguageKey: "Untuk sekarang, request Anda belum diterima oleh host. Mohon menunggu."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      noPromptButton: (context, action) {
        return Text("Exit".tr);
      },
      yesPromptButton: (context, action) {
        return Text("Request Again".tr);
      },
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
      onYesPromptButtonTap: (_) async {
        Get.back();
        showSharedCartOptionsPrompt(context);
      },
    );
  }

  void showRequestJoinBucketIsSuccess(BuildContext context) {
    DialogHelper.showPromptOkDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "You Have Requested To Join",
              Constant.textInIdLanguageKey: "Anda Sudah Request Join"
            }).toEmptyStringNonNull,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "For now, your Request Has Not Been Accepted By The Host. Please wait.",
              Constant.textInIdLanguageKey: "Untuk sekarang, request Anda belum diterima oleh host. Mohon menunggu."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onOkPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showProductBrandDescription({
    required BuildContext context,
    required ProductBrand productBrand
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16.0),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: Constant.aspectRatioValueBrandImage.toDouble(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ModifiedCachedNetworkImage(
                        imageUrl: productBrand.bannerMobile.isNotEmptyString ? productBrand.bannerMobile! : productBrand.bannerDesktop.toEmptyStringNonNull,
                      )
                    )
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "${"Description".tr}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 10),
                  Text(productBrand.description.toStringNonNull),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void showSelectingImageDialog(BuildContext context, {dynamic parameter, double? cropAspectRatio, void Function(String)? onImageSelectedWithoutCropping, void Function()? onRemoveImage}) {
    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Select Image With",
                      Constant.textInIdLanguageKey: "Pilih Gambar Dengan"
                    }).toStringNonNull,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    DialogHelper.showLoadingDialog(context);
                    ImagePicker imagePicker = ImagePicker();
                    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      if (onImageSelectedWithoutCropping != null) {
                        onImageSelectedWithoutCropping(pickedImage.path);
                        Get.back();
                      } else {
                        CropPictureParameter cropPictureParameter = CropPictureParameter(
                          parameter: parameter,
                          picturePath: pickedImage.path,
                          cropAspectRatio: cropAspectRatio,
                        );
                        // ignore: use_build_context_synchronously
                        PageRestorationHelper.toCropPicturePage(context, cropPictureParameter);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  icon: (BuildContext context) => const Icon(Icons.image),
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Gallery",
                    Constant.textInIdLanguageKey: "Galeri"
                  }).toStringNonNull,
                ),
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    DialogHelper.showLoadingDialog(context);
                    ImagePicker imagePicker = ImagePicker();
                    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      if (onImageSelectedWithoutCropping != null) {
                        onImageSelectedWithoutCropping(pickedImage.path);
                        Get.back();
                      } else {
                        CropPictureParameter cropPictureParameter = CropPictureParameter(
                          parameter: parameter,
                          picturePath: pickedImage.path,
                          cropAspectRatio: cropAspectRatio,
                        );
                        // ignore: use_build_context_synchronously
                        PageRestorationHelper.toCropPicturePage(context, cropPictureParameter);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  icon: (BuildContext context) => const Icon(Icons.camera),
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Camera",
                    Constant.textInIdLanguageKey: "Kamera"
                  }).toStringNonNull
                ),
                if (onRemoveImage != null)
                  ProfileMenuItem(
                    onTap: () {
                      onRemoveImage();
                      Get.back();
                    },
                    icon: (BuildContext context) => const Icon(Icons.delete),
                    title: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Remove Image",
                      Constant.textInIdLanguageKey: "Hapus Gambar"
                    }).toStringNonNull
                  )
              ],
            ),
          ),
        );
      }
    );
  }

  void showAddressOtherMenu({
    required BuildContext context,
    required Address address,
    required void Function(Address) onChangeAddress,
    required void Function(Address) onRemoveAddress
  }) {
    showModalBottomSheetPage(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModifiedAppBar(
            primary: false,
            title: Text("Other Choice".tr)
          ),
          SafeArea(
            top: false,
            child: Column(
              children: [
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    onChangeAddress(address);
                  },
                  title: 'Change Address'.tr,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  child: const ModifiedDivider()
                ),
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    DialogHelper.showPromptYesNoDialog(
                      context: context,
                      prompt: (context) => Column(
                        children: [
                          Text("Remove Address".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 5),
                          Text("${"Are you sure remove address".tr}?"),
                          const SizedBox(height: 5),
                        ]
                      ),
                      onYesPromptButtonTap: (_) {
                        Get.back();
                        onRemoveAddress(address);
                      },
                      onNoPromptButtonTap: (context) => Get.back(),
                    );
                  },
                  title: 'Remove Address'.tr,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  child: const ModifiedDivider()
                ),
                SizedBox(height: Constant.paddingListItem)
              ]
            )
          )
        ]
      )
    );
  }

  void showOrderListIsClosed(BuildContext context) {
    DialogHelper.showPromptOkDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Orderlist is Closed",
              Constant.textInIdLanguageKey: "Orderlist Sudah Ditutup"
            }).toEmptyStringNonNull,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Because orderlist is closed, you cannot add warehouse again.",
              Constant.textInIdLanguageKey: "Karena orderlist sudah ditutup, Anda tidak dapat menambahkan warehouse lagi."
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onOkPromptButtonTap: (_) async {
        Get.back();
      },
    );
  }

  void showLeaveBucketPrompt(BuildContext context, void Function() leaveBucket) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Leave Bucket",
              Constant.textInIdLanguageKey: "Tinggalkan Bucket"
            }).toEmptyStringNonNull,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure to leave this bucket?",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin meninggalkan bucket ini?"
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
      onYesPromptButtonTap: (_) async {
        Get.back();
        leaveBucket();
      },
    );
  }

  void showDestroyBucketPrompt(BuildContext context, void Function() destroyBucket) {
    DialogHelper.showPromptYesNoDialog(
      context: context,
      prompt: (context) => Column(
        children: [
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Destroy Bucket",
              Constant.textInIdLanguageKey: "Hapus Bucket"
            }).toEmptyStringNonNull,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
          Text(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Are you sure to menghapus this bucket? ",
              Constant.textInIdLanguageKey: "Apakah anda yakin ingin menghapus bucket ini?"
            }).toEmptyStringNonNull,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 4),
        ]
      ),
      onNoPromptButtonTap: (_) async {
        Get.back();
      },
      onYesPromptButtonTap: (_) async {
        Get.back();
        destroyBucket();
      },
    );
  }

  Future<T?> showModalBottomSheetPage<T>({
    required BuildContext context,
    Color? backgroundColor = Colors.transparent,
    required WidgetBuilder builder,
    bool enableDrag = false
  }) async {
    return Get.bottomSheetOriginalMethod<T>(
      context,
      builder(context),
      ignoreSafeArea: false,
      isScrollControlled: true,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
    );
  }

  _showRawPromptModalBottomDialog({
    required BuildContext context,
    required WidgetBuilder builder
  }) {
    return showModalBottomSheetPage(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.all(4.w),
        child: builder(context)
      )
    );
  }

  Future<T?> showModalBottomDialogPage<T, P>({
    required BuildContext context,
    required ModalDialogPageBuilder<dynamic, P> modalDialogPageBuilder,
    P? parameter,
    bool enableDrag = false
  }) async {
    dynamic result = await showModalBottomSheetPage(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => GetxPageBuilder.buildDefaultGetxPage(modalDialogPageBuilder(context, parameter)),
      enableDrag: enableDrag
    );
    return result is T ? result : null;
  }

  Future<T?> showDialogPage<T>({
    required BuildContext context,
    Color? backgroundColor = Colors.transparent,
    required WidgetBuilder builder,
    bool enableDrag = false,
    bool barrierDismissible = true
  }) async {
    return Get.dialogOriginalMethod<T>(
      context,
      builder(context),
      barrierDismissible: barrierDismissible
    );
  }

  Future<T?> showModalDialogPage<T, P>({
    required BuildContext context,
    required ModalDialogPageBuilder<dynamic, P> modalDialogPageBuilder,
    P? parameter,
    bool enableDrag = false,
    bool barrierDismissible = true
  }) async {
    dynamic result = await showDialogPage(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => GetxPageBuilder.buildDefaultGetxPage(modalDialogPageBuilder(context, parameter)),
      enableDrag: enableDrag,
      barrierDismissible: barrierDismissible
    );
    return result is T ? result : null;
  }

  showFailedModalBottomDialog({
    required BuildContext context,
    String? buttonText,
    Image? image,
    String? promptTitleText = "Success",
    String? promptText = "This process has been success...",
    void Function()? onPressed
  }) {
    return _showRawPromptModalBottomDialog(
      context: context,
      builder: (context) => WidgetHelper.buildFailedPromptIndicator(
        context: context,
        image: image,
        promptText: promptText,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Get.back(result: true)
      )
    );
  }

  showFailedModalBottomDialogFromErrorProvider({
    required BuildContext context,
    required ErrorProvider errorProvider,
    required dynamic e,
    String? buttonText,
    void Function()? onPressed
  }) {
    return _showRawPromptModalBottomDialog(
      context: context,
      builder: (context) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
        context: context,
        errorProvider: errorProvider,
        e: e,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Get.back(result: true)
      )
    );
  }

  Future<FilePickerResult?> showChooseFileOrTakePhoto({bool allowMultipleSelectFiles = false}) async {
    return await FilePicker.platform.pickFiles(
      allowMultiple: allowMultipleSelectFiles
    );
  }
}

// ignore: non_constant_identifier_names
final _DialogHelperImpl DialogHelper = _DialogHelperImpl();