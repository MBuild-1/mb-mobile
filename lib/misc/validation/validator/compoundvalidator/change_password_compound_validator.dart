import '../validator.dart';
import 'compound_validator.dart';

class ChangePasswordCompoundValidator extends CompoundValidator {
  Validator currentPasswordValidator;
  Validator passwordValidator;
  Validator passwordConfirmationValidator;

  ChangePasswordCompoundValidator({
    required this.currentPasswordValidator,
    required this.passwordValidator,
    required this.passwordConfirmationValidator
  }) : super(validatorList: []) {
    validatorList.add(currentPasswordValidator);
    validatorList.add(passwordValidator);
    validatorList.add(passwordConfirmationValidator);
  }
}