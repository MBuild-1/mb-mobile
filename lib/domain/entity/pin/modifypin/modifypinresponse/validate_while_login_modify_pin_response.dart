import '../../../login/login_response.dart';
import 'validate_modify_pin_response.dart';

class ValidateWhileLoginModifyPinResponse extends ValidateModifyPinResponse {
  LoginResponse loginResponse;

  ValidateWhileLoginModifyPinResponse({
    required this.loginResponse
  });
}