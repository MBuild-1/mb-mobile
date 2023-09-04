import 'modify_pin_parameter.dart';

class ChangeModifyPinParameter extends ModifyPinParameter {
  String currentPin;
  String newPin;
  String confirmNewPin;

  ChangeModifyPinParameter({
    required this.currentPin,
    required this.newPin,
    required this.confirmNewPin
  });
}