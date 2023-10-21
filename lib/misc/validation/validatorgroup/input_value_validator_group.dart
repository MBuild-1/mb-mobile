import '../validator/validator.dart';
import 'validator_group.dart';

class InputValueValidatorGroup extends ValidatorGroup {
  Validator inputValueValidator;

  InputValueValidatorGroup({
    required this.inputValueValidator
  }) {
    validatorList.add(inputValueValidator);
  }
}