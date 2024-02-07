import '../auth_identity_step.dart';

abstract class VerifyAuthIdentityStep extends AuthIdentityStep {
  @override
  int get stepNumber => 2;
}