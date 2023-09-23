import 'validate_modify_pin_parameter.dart';

class ValidateWhileLoginModifyPinParameter extends ValidateModifyPinParameter {
  String data;

  ValidateWhileLoginModifyPinParameter({
    required super.pin,
    required this.data
  });
}