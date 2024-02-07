import 'modify_pin_parameter.dart';

class CreateModifyPinParameter extends ModifyPinParameter {
  String pin;
  String confirmPin;

  CreateModifyPinParameter({
    required this.pin,
    required this.confirmPin
  });
}