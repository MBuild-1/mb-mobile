import '../validator/validator.dart';
import 'validator_group.dart';

class ForgotPasswordValidatorGroup extends ValidatorGroup {
  Validator emailOrPhoneNumberValidator;

  ForgotPasswordValidatorGroup({
    required this.emailOrPhoneNumberValidator,
  }) {
    validatorList.add(emailOrPhoneNumberValidator);
  }
}