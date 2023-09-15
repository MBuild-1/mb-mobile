import '../validator/compoundvalidator/change_password_compound_validator.dart';
import 'validator_group.dart';

class ChangePasswordValidatorGroup extends ValidatorGroup {
  ChangePasswordCompoundValidator changePasswordCompoundValidator;

  ChangePasswordValidatorGroup({
    required this.changePasswordCompoundValidator,
  }) {
    validatorList.add(changePasswordCompoundValidator);
  }
}