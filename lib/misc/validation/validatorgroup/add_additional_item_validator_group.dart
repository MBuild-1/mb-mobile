import '../validator/validator.dart';
import 'validator_group.dart';

class AddAdditionalItemValidatorGroup extends ValidatorGroup {
  Validator additionalItemNameValidator;
  Validator additionalItemEstimationPriceValidator;
  Validator additionalItemEstimationWeightValidator;
  Validator additionalItemQuantityValidator;
  Validator additionalItemNotesValidator;

  AddAdditionalItemValidatorGroup({
    required this.additionalItemNameValidator,
    required this.additionalItemEstimationPriceValidator,
    required this.additionalItemEstimationWeightValidator,
    required this.additionalItemQuantityValidator,
    required this.additionalItemNotesValidator
  }) {
    validatorList.add(additionalItemNameValidator);
    validatorList.add(additionalItemEstimationPriceValidator);
    validatorList.add(additionalItemEstimationWeightValidator);
    validatorList.add(additionalItemQuantityValidator);
    validatorList.add(additionalItemNotesValidator);
  }
}