import '../validator/compoundvalidator/password_compound_validator.dart';
import 'validator_group.dart';

class ResetPasswordValidatorGroup extends ValidatorGroup {
  PasswordCompoundValidator resetPasswordCompoundValidator;

  ResetPasswordValidatorGroup({
    required this.resetPasswordCompoundValidator
  }) {
    validatorList.add(resetPasswordCompoundValidator);
  }
}