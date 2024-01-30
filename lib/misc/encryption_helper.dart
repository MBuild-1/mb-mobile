import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class _EncryptionHelperImpl {
  String decryptAESCryptoJS(String encryptedText, String salt, String password, String iv) {
    String a = String.fromCharCodes(base64.decode(encryptedText));
    print("Encrypted text: $encryptedText");
    print("Decoded Encrypted text: ${a.length}");
    CBCBlockCipher cipher = CBCBlockCipher(BlockCipher("AES"));
    Uint8List ciphertextlist = base64.decode(encryptedText);
    Uint8List key = _generateKey(password, Uint8List.fromList(salt.codeUnits));
    Uint8List encrypted = ciphertextlist;
    ParametersWithIV<KeyParameter> params = ParametersWithIV<KeyParameter>(KeyParameter(key), Uint8List.fromList(iv.codeUnits));
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter> paddingParams = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter>(params, null);
    PaddedBlockCipherImpl paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);
    var val = paddingCipher.process(encrypted);
    String decrypted = String.fromCharCodes(val);
    return decrypted;
  }

  Uint8List _generateKey(String passphrase, Uint8List salt) {
    Uint8List passphraseInt8List = Uint8List.fromList(passphrase.codeUnits);
    KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64));
    Pbkdf2Parameters params = Pbkdf2Parameters(salt, 65556, 32);
    derivator.init(params);
    return derivator.process(passphraseInt8List);
  }
}

// ignore: non_constant_identifier_names
var EncryptionHelper = _EncryptionHelperImpl();