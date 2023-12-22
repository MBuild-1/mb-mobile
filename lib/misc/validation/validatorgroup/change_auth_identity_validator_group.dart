import '../validator/validator.dart';
import 'validator_group.dart';

class ChangeAuthIdentityValidatorGroup extends ValidatorGroup {
  Validator changeAuthIdentityValidator;

  ChangeAuthIdentityValidatorGroup({
    required this.changeAuthIdentityValidator
  }) {
    validatorList.add(changeAuthIdentityValidator);
  }
}