import '../validator/compoundvalidator/password_compound_validator.dart';
import 'validator_group.dart';

class ChangePasswordValidatorGroup extends ValidatorGroup {
  PasswordCompoundValidator passwordCompoundValidator;

  ChangePasswordValidatorGroup({
    required this.passwordCompoundValidator,
  }) {
    validatorList.add(passwordCompoundValidator);
  }
}