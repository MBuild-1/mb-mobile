import 'package:masterbagasi/main.dart' as starter_main;

import '../misc/environmentconfig/environment_config.dart';
import '../misc/environmentconfig/staging_environment_config.dart';

void main() async {
  EnvironmentConfig.instance = StagingEnvironmentConfig();
  await starter_main.main();
}