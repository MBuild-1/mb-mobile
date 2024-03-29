import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../domain/entity/login/third_party_login_visibility_parameter.dart';
import '../domain/entity/versioning/versioning.dart';
import '../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../presentation/notifier/third_party_login_notifier.dart';
import '../presentation/notifier/versioning_notifier.dart';
import 'constant.dart';
import 'dialog_helper.dart';
import 'error/message_error.dart';
import 'load_data_result.dart';
import 'multi_language_string.dart';
import 'trackingstatusresult/success_but_skip_process_tracking_status_result.dart';
import 'trackingstatusresult/success_tracking_status_result.dart';
import 'trackingstatusresult/tracking_status_result.dart';

class _DeviceHelperImpl {
  String getLowercaseDeviceName({
    bool separateSpecificAppleDeviceName = false
  }) {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS || Platform.isMacOS) {
      if (!separateSpecificAppleDeviceName) {
        return "apple";
      } else {
        if (Platform.isIOS) {
          return "ios";
        } else if (Platform.isMacOS) {
          return "macos";
        }
      }
    } else if (Platform.isFuchsia) {
      return "fuchsia";
    } else if (Platform.isLinux) {
      return "linux";
    } else if (Platform.isWindows) {
      return "windows";
    }
    return "";
  }

  Future<LoadDataResult<TrackingStatusResult>> requestTrackingAuthorization() async {
    Future<TrackingStatusResult> onRequestTrackingAuthorization() async {
      if (!Platform.isIOS) {
        return SuccessButSkipProcessTrackingStatusResult(
          e: PlatformException(
            code: "999",
            message: MultiLanguageString({
              Constant.textEnUsLanguageKey: "This tracking authorization feature required iOS as device operating system.",
              Constant.textInIdLanguageKey: "Fitur otorisasi pelacakan ini memerlukan iOS sebagai sistem operasi perangkat."
            }).toEmptyStringNonNull
          )
        );
      }
      TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }
      if (status == TrackingStatus.authorized) {
        return SuccessTrackingStatusResult(
          trackingStatus: status
        );
      }
      late MultiLanguageString errorMessage;
      if (status == TrackingStatus.denied) {
        errorMessage = MultiLanguageString({
          Constant.textEnUsLanguageKey: "This tracking authorization is denied.",
          Constant.textInIdLanguageKey: "Otorisasi pelacakan ini ditolak."
        });
      } else if (status == TrackingStatus.restricted) {
        errorMessage = MultiLanguageString({
          Constant.textEnUsLanguageKey: "This tracking authorization is restricted.",
          Constant.textInIdLanguageKey: "Otorisasi pelacakan ini dibatasi."
        });
      } else if (status == TrackingStatus.notSupported) {
        errorMessage = MultiLanguageString({
          Constant.textEnUsLanguageKey: "This tracking authorization is not supported.",
          Constant.textInIdLanguageKey: "Otorisasi pelacakan ini tidak didukung."
        });
      } else {
        errorMessage = MultiLanguageString({
          Constant.textEnUsLanguageKey: "Tracking status is unknown.",
          Constant.textInIdLanguageKey: "Status pelacakan tidak diketahui."
        });
      }
      throw MultiLanguageMessageError(
        title: MultiLanguageString({
          Constant.textEnUsLanguageKey: "There Is Error in Tracking Authorization",
          Constant.textInIdLanguageKey: "Ada Kesalahan di Otorisasi pelacakan"
        }),
        message: errorMessage
      );
    }
    return onRequestTrackingAuthorization().getLoadDataResult<TrackingStatusResult>();
  }

  Future<void> updateApplication() {
    return OpenStore.instance.open(
      appStoreId: '6473609788',
      androidAppBundleId: 'com.masterbagasi.masterbagasi'
    );
  }

  void initVersioningNotifierAndCheckUpdate(BuildContext context) {
    VersioningNotifier versioningNotifier = Provider.of<VersioningNotifier>(context, listen: false);
    versioningNotifier.setVersioningNotifierDelegate(
      VersioningNotifierDelegate(
        onGetSpecifiedVersioningBasedFilterResponse: (specifiedVersioningBasedFilterResponse) async {
          Versioning versioning = specifiedVersioningBasedFilterResponse.versioning;
          if (versioning.mustBeUpdatedToNewerVersion == 1) {
            if (versioning.isLatest != 1) {
              DialogHelper.showPromptAppMustBeUpdated(context);
            }
          }
        }
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PackageInfo.fromPlatform().then((packageInfo) {
        versioningNotifier.checkUpdate(
          VersioningBasedFilterParameter(
            version: packageInfo.version,
            buildNumber: int.parse(packageInfo.buildNumber),
            deviceName: getLowercaseDeviceName(
              separateSpecificAppleDeviceName: true
            )
          )
        );
      });
    });
  }

  void checkThirdPartyLoginVisibility(BuildContext context) {
    ThirdPartyLoginNotifier thirdPartyLoginNotifier = Provider.of<ThirdPartyLoginNotifier>(context, listen: false);
    thirdPartyLoginNotifier.resetThirdPartyLoginVisibilityValue();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PackageInfo.fromPlatform().then((packageInfo) {
        thirdPartyLoginNotifier.checkThirdPartyLoginVisibility(
          ThirdPartyLoginVisibilityParameter(
            version: packageInfo.version,
            buildNumber: int.parse(packageInfo.buildNumber),
            deviceName: getLowercaseDeviceName(
              separateSpecificAppleDeviceName: true
            )
          )
        );
      });
    });
  }
}

// ignore: non_constant_identifier_names
final _DeviceHelperImpl DeviceHelper = _DeviceHelperImpl();