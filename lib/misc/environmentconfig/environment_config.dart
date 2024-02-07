import 'no_environment_config.dart';

abstract class EnvironmentConfig {
  static EnvironmentConfig instance = NoEnvironmentConfig();

  String get environment;
  String get baseUrl;
  String get elasticEntryEndpointPath;
  String get midtransSnapUrl;
}