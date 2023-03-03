import 'package:flutter/material.dart';

import '../constant.dart';
import 'extended_translation.dart';

class DefaultExtendedTranslation extends ExtendedTranslation {
  @override
  Map<String, Map<String, String>> get keys => {
    Constant.textInIdLanguageKey: {
      "Start": "Mulai",
      "Next": "Selanjutnya",
      "Skip": "Lewati",
      "Other Method": "Metode Lain",
      "or login with": "atau daftar dengan",
      "This input must be an email": "Inputannya harus berupa email",
      "Email is required": "Email dibutuhkan",
      "Login": "Masuk",
      "Register": "Daftar",
      "Name is required": "Nama dibutuhkan",
      "Password is required": "Password dibutuhkan",
      "Password confirmation is required": "Konfirmasi password dibutuhkan",
      "Password must be same with password confirmation": "Password harus sama dengan konfirmasi password"
    }
  };

  @override
  Map<String, Map<String, OnInitTextSpan>> get keysForTextSpan => {
    'default': {
      'New to MasterBagasi': (signUpTapGestureRecognizer) => TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: "Don't have a MasterBagasi account yet? ",
          ),
          TextSpan(
            text: "Sign Up",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signUpTapGestureRecognizer
          ),
        ]
      ),
      'By signing up': (signInRecognizer) => TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: "${"By signing up, you’re agree to our"} "),
          TextSpan(
            text: "Terms & Conditions",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signInRecognizer.termAndConditionsTapGestureRecognizer
          ),
          const TextSpan(text: " ${"and"} "),
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signInRecognizer.privacyPolicyTapGestureRecognizer
          ),
        ]
      ),
    },
    'in_ID': {
      'New to MasterBagasi': (signUpTapGestureRecognizer) => TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: "Belum punya akun MasterBagasi? ",
          ),
          TextSpan(
            text: "Daftar",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signUpTapGestureRecognizer
          ),
        ]
      ),
      'By signing up': (signUpRecognizer) => TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: "${"Dengan mendaftar, kamu menyetujui"} "),
          TextSpan(
            text: "Syarat & Ketentuan",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signUpRecognizer.termAndConditionsTapGestureRecognizer
          ),
          const TextSpan(text: " ${"serta"} "),
          TextSpan(
            text: "Kebijakan Privasi",
            style: TextStyle(color: Constant.colorHyperlink),
            recognizer: signUpRecognizer.privacyPolicyTapGestureRecognizer
          ),
        ]
      ),
    }
  };
}