import '../auth_identity_step.dart';

abstract class ChangeAuthIdentityStep extends AuthIdentityStep {
  @override
  int get stepNumber => 3;
}