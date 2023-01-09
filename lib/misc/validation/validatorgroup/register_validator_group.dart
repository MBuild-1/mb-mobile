import '../validator/validator.dart';
import 'validator_group.dart';

class RegisterValidatorGroup extends ValidatorGroup {
  Validator emailValidator;
  Validator usernameValidator;
  Validator mobileNumberValidator;
  Validator passwordValidator;

  RegisterValidatorGroup({
    required this.emailValidator,
    required this.usernameValidator,
    required this.mobileNumberValidator,
    required this.passwordValidator
  }) {
    validatorList.add(emailValidator);
    validatorList.add(usernameValidator);
    validatorList.add(mobileNumberValidator);
    validatorList.add(passwordValidator);
  }
}