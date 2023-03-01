import '../validator/validator.dart';
import 'validator_group.dart';

class RegisterValidatorGroup extends ValidatorGroup {
  Validator emailValidator;
  Validator nameValidator;
  Validator passwordValidator;
  Validator passwordConfirmationValidator;

  RegisterValidatorGroup({
    required this.emailValidator,
    required this.nameValidator,
    required this.passwordValidator,
    required this.passwordConfirmationValidator
  }) {
    validatorList.add(emailValidator);
    validatorList.add(nameValidator);
    validatorList.add(passwordValidator);
    validatorList.add(passwordConfirmationValidator);
  }
}