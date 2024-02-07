import '../../load_data_result.dart';
import 'change_auth_identity_step.dart';

class PhoneChangeAuthIdentityStep extends ChangeAuthIdentityStep {
  LoadDataResult<List<String>> countryCodeListLoadDataResult;

  PhoneChangeAuthIdentityStep({
    required this.countryCodeListLoadDataResult
  });
}