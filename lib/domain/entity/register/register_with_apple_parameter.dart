import '../../../misc/apple_sign_in_credential.dart';

class RegisterWithAppleParameter {
  AppleSignInCredential appleSignInCredential;
  String pushNotificationSubscriptionId;
  String deviceName;

  RegisterWithAppleParameter({
    required this.appleSignInCredential,
    required this.pushNotificationSubscriptionId,
    required this.deviceName
  });
}