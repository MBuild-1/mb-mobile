import '../validator/validator.dart';
import 'validator_group.dart';

class RegisterValidatorGroup extends ValidatorGroup {
  Validator emailOrPhoneNumberValidator;

  RegisterValidatorGroup({
    required this.emailOrPhoneNumberValidator
  }) {
    validatorList.add(emailOrPhoneNumberValidator);
  }
}