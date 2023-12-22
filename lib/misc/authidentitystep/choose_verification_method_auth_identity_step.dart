import '../../domain/entity/verifyeditprofile/authidentity/auth_identity_parameter_and_response.dart';
import 'auth_identity_step.dart';

class ChooseVerificationMethodAuthIdentityStep extends AuthIdentityStep {
  AuthIdentityParameterAndResponse authIdentityParameterAndResponse;

  ChooseVerificationMethodAuthIdentityStep({
    required this.authIdentityParameterAndResponse
  });

  @override
  int get stepNumber => 1;
}