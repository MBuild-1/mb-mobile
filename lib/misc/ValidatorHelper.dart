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

  Validator getPasswordValidator(String password) {
    return Validator(
      onValidate: () {
        String multiLanguageErrorMessage({
          required String enUsErrorMessage,
          required String inIdErrorMessage
        }) {
          return MultiLanguageString({
            Constant.textEnUsLanguageKey: enUsErrorMessage,
            Constant.textInIdLanguageKey: inIdErrorMessage
          }).toEmptyStringNonNull;
        }
        bool containsLetters(String password) {
          return password.contains(RegExp(r'[a-zA-Z]'));
        }
        bool containsMixedCase(String password) {
          return password.contains(RegExp(r'[a-z]')) &&password.contains(RegExp(r'[A-Z]'));
        }
        bool containsNumbers(String password) {
          return password.contains(RegExp(r'[0-9]'));
        }
        bool containsSymbols(String password) {
          return password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
        }
        String errorResult = "";
        List<String> errors = [];
        if (password.isEmpty) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password is required.",
              inIdErrorMessage: "Kata sandi dibutuhkan."
            )
          );
        }
        if (password.length < 8) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password must be at least 8 characters long.",
              inIdErrorMessage: "Kata sandi harus terdiri dari minimal 8 karakter."
            )
          );
        }
        if (!containsLetters(password)) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password must contain letters.",
              inIdErrorMessage: "Kata sandi harus mengandung huruf."
            )
          );
        }
        if (!containsMixedCase(password)) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password must contain both upper and lower case letters.",
              inIdErrorMessage: "Kata sandi harus mengandung huruf besar dan kecil."
            )
          );
        }
        if (!containsNumbers(password)) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password must contain numbers",
              inIdErrorMessage: "Kata sandi harus berisi angka"
            )
          );
        }
        if (!containsSymbols(password)) {
          errors.add(
            multiLanguageErrorMessage(
              enUsErrorMessage: "Password must contain symbols",
              inIdErrorMessage: "Kata sandi harus mengandung simbol"
            )
          );
        }
        int i = 0;
        while (i < errors.length) {
          errorResult += "${errorResult.isNotEmptyString ? "\r\n" : ""}${"- "}${errors[i]}";
          i++;
        }
        return errorResult.isNotEmptyString
          ? FailedValidationResult(e: ValidationError(message: errorResult))
          : SuccessValidationResult();
      }
    );
  }
}

// ignore: non_constant_identifier_names
final _ValidatorHelperImpl ValidatorHelper = _ValidatorHelperImpl();