import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';

import 'constant.dart';
import 'error/validation_error.dart';
import 'load_data_result.dart';
import 'multi_language_string.dart';
import 'validation/validation_result.dart';
import 'validation/validationresult/is_phone_number_success_validation_result.dart';
import 'validation/validator/validator.dart';

class _ValidatorHelperImpl {
  Validator getEmailOrPhoneNumberValidator({
    required ValidationResult Function() onCheckingAfterValidateEmailOrPhoneNumber,
    required Validator Function() onGetEmailOrPhoneNumberValidator,
    required String Function() onGetEmailOrPhoneNumberRegisterInput,
    required LoadDataResult<List<String>> Function() onGetCountryCodeListLoadDataResult,
    void Function(ValidationResult)? onGetEmailOrPhoneTypeValidationResult,
  }) {
    return Validator(
      onValidate: () {
        String emailOrPhoneNumber = onGetEmailOrPhoneNumberRegisterInput();
        Validator emailOrPhoneNumberValidator = onGetEmailOrPhoneNumberValidator();
        // ignore: invalid_use_of_protected_member
        ValidationResult validationResult = emailOrPhoneNumberValidator.validating();
        if (onGetEmailOrPhoneTypeValidationResult != null) {
          onGetEmailOrPhoneTypeValidationResult(validationResult);
        }
        if (validationResult.isSuccess) {
          ValidationResult onCheckingAfterValidateEmailOrPhoneNumberResult = onCheckingAfterValidateEmailOrPhoneNumber();
          if (onCheckingAfterValidateEmailOrPhoneNumberResult is SuccessValidationResult) {
            LoadDataResult<List<String>> countryCodeListLoadDataResult = onGetCountryCodeListLoadDataResult();
            if (countryCodeListLoadDataResult.isSuccess) {
              List<String> countryCodeList = countryCodeListLoadDataResult.resultIfSuccess!;
              if (validationResult is IsPhoneNumberSuccessValidationResult) {
                int step = 1;
                String temp = "";
                for (int i = 0; i < emailOrPhoneNumber.length; i++) {
                  String c = emailOrPhoneNumber[i];
                  if (c.isNum) {
                    temp += c;
                  }
                  if (step == 1) {
                    if (temp.isNotEmpty && temp.length <= 3) {
                      if (countryCodeList.where((countryCode) => countryCode == temp).isNotEmpty) {
                        return SuccessValidationResult();
                      }
                    }
                    if (temp.length == 1) {
                      if (temp == "0") {
                        return SuccessValidationResult();
                      }
                    }
                  }
                }
                return FailedValidationResult(
                  e: ValidationError(
                    message: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Country phone code is not suitable.",
                      Constant.textInIdLanguageKey: "Kode telepon negara tidak ada yang sesuai."
                    }).toStringNonNull
                  )
                );
              }
              return validationResult;
            } else {
              return FailedValidationResult(
                e: ValidationError(
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Country phone code cannot be checked.",
                    Constant.textInIdLanguageKey: "Kode telepon negara tidak bisa dicek."
                  }).toStringNonNull
                )
              );
            }
          } else {
            return onCheckingAfterValidateEmailOrPhoneNumberResult;
          }
        }
        return validationResult;
      }
    );
  }
}

// ignore: non_constant_identifier_names
final _ValidatorHelperImpl ValidatorHelper = _ValidatorHelperImpl();