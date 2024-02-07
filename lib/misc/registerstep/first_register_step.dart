import '../../domain/entity/address/country.dart';
import '../load_data_result.dart';
import 'register_step.dart';

class FirstRegisterStep extends RegisterStep {
  LoadDataResult<List<String>> countryCodeListLoadDataResult;

  FirstRegisterStep({
    required this.countryCodeListLoadDataResult
  });

  @override
  int get stepNumber => 1;
}