import 'dart:io';

class _DeviceHelperImpl {
  String getLowercaseDeviceName() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS || Platform.isMacOS) {
      return "apple";
    } else if (Platform.isFuchsia) {
      return "fuchsia";
    } else if (Platform.isLinux) {
      return "linux";
    } else if (Platform.isWindows) {
      return "windows";
    } else {
      return "";
    }
  }
}

// ignore: non_constant_identifier_names
final _DeviceHelperImpl DeviceHelper = _DeviceHelperImpl();