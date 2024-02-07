import 'package:masterbagasi/main.dart' as starter_main;

import '../misc/environmentconfig/environment_config.dart';
import '../misc/environmentconfig/prod_environment_config.dart';

void main() async {
  EnvironmentConfig.instance = ProdEnvironmentConfig();
  await starter_main.main();
}