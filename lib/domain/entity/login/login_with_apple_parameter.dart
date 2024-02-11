import '../../../misc/apple_sign_in_credential.dart';

class LoginWithAppleParameter {
  AppleSignInCredential appleSignInCredential;
  String pushNotificationSubscriptionId;
  String deviceName;

  LoginWithAppleParameter({
    required this.appleSignInCredential,
    required this.pushNotificationSubscriptionId,
    required this.deviceName
  });
}