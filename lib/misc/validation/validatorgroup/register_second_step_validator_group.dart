import '../validator/compoundvalidator/password_compound_validator.dart';
import '../validator/validator.dart';
import 'validator_group.dart';

class RegisterSecondStepValidatorGroup extends ValidatorGroup {
  Validator nameValidator;
  PasswordCompoundValidator passwordCompoundValidator;

  RegisterSecondStepValidatorGroup({
    required this.nameValidator,
    required this.passwordCompoundValidator
  }) {
    validatorList.add(nameValidator);
    validatorList.add(passwordCompoundValidator);
  }
}