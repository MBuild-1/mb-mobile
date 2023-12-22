import '../validator/validator.dart';
import 'validator_group.dart';

class VerifyAuthIdentityValidatorGroup extends ValidatorGroup {
  Validator verifyAuthIdentityValidator;

  VerifyAuthIdentityValidatorGroup({
    required this.verifyAuthIdentityValidator
  }) {
    validatorList.add(verifyAuthIdentityValidator);
  }
}