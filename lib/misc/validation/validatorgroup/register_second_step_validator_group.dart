import '../validator/compoundvalidator/password_compound_validator.dart';
import '../validator/validator.dart';
import 'validator_group.dart';

class RegisterSecondStepValidatorGroup extends ValidatorGroup {
  Validator usernameValidator;
  Validator nameValidator;
  Validator genderValidator;
  PasswordCompoundValidator passwordCompoundValidator;

  RegisterSecondStepValidatorGroup({
    required this.usernameValidator,
    required this.nameValidator,
    required this.genderValidator,
    required this.passwordCompoundValidator
  }) {
    validatorList.add(usernameValidator);
    validatorList.add(nameValidator);
    validatorList.add(genderValidator);
    validatorList.add(passwordCompoundValidator);
  }
}