import '../validator/validator.dart';
import 'validator_group.dart';

class LoginValidatorGroup extends ValidatorGroup {
  Validator emailOrPhoneNumberValidator;
  Validator passwordValidator;

  LoginValidatorGroup({
    required this.emailOrPhoneNumberValidator,
    required this.passwordValidator
  }) {
    validatorList.add(emailOrPhoneNumberValidator);
    validatorList.add(passwordValidator);
  }
}