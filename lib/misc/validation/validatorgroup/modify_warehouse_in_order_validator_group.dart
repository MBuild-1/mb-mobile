import '../validator/validator.dart';
import 'validator_group.dart';

class ModifyWarehouseInOrderValidatorGroup extends ValidatorGroup {
  Validator nameValidator;
  Validator priceValidator;
  Validator weightValidator;
  Validator quantityValidator;
  Validator notesValidator;

  ModifyWarehouseInOrderValidatorGroup({
    required this.nameValidator,
    required this.priceValidator,
    required this.weightValidator,
    required this.quantityValidator,
    required this.notesValidator
  }) {
    validatorList.add(nameValidator);
    validatorList.add(priceValidator);
    validatorList.add(weightValidator);
    validatorList.add(quantityValidator);
    validatorList.add(notesValidator);
  }
}