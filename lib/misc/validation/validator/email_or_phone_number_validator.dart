import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../error/validation_error.dart';
import '../validation_result.dart';
import '../validationresult/is_email_success_validation_result.dart';
import '../validationresult/is_phone_number_success_validation_result.dart';
import 'validator.dart';

typedef _EmailOrPhoneNumberValidatorStringParameter = String Function();

class EmailOrPhoneNumberValidator extends Validator {
  final OnValidate? _onValidateAfterValidateEmailOrPhoneNumberFormat;
  // ignore: library_private_types_in_public_api
  final _EmailOrPhoneNumberValidatorStringParameter emailOrPhoneNumber;

  EmailOrPhoneNumberValidator({
    required this.emailOrPhoneNumber,
    OnValidate? onValidateAfterValidateEmailOrPhoneNumberFormat
  }) : _onValidateAfterValidateEmailOrPhoneNumberFormat = onValidateAfterValidateEmailOrPhoneNumberFormat,
        super.nullableOnValidate(
          onValidate: null
      );

  @override
  ValidationResult validating() {
    String emailOrPhoneNumberValue = emailOrPhoneNumber();
    if (emailOrPhoneNumberValue.isEmptyString) {
      return FailedValidationResult(e: ValidationError(message: "${"Email or phone number is required".tr}."));
    } else if (!(emailOrPhoneNumberValue.isEmail || emailOrPhoneNumberValue.isPhoneNumber)) {
      return FailedValidationResult(e: ValidationError(message: "${"This input must be an email or phone number".tr}."));
    } else {
      if (_onValidateAfterValidateEmailOrPhoneNumberFormat != null) {
        _onValidateAfterValidateEmailOrPhoneNumberFormat!();
      }
      if (emailOrPhoneNumberValue.isEmail) {
        return IsEmailSuccessValidationResult();
      } else if (emailOrPhoneNumberValue.isPhoneNumber) {
        return IsPhoneNumberSuccessValidationResult();
      } else {
        return SuccessValidationResult();
      }
    }
  }
}