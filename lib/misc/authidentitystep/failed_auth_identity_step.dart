import 'auth_identity_step.dart';

class FailedAuthIdentityStep extends AuthIdentityStep {
  dynamic e;

  FailedAuthIdentityStep({
    required this.e
  });

  @override
  int get stepNumber => -2;
}