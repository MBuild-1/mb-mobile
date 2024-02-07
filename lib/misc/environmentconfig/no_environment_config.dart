import 'environment_config.dart';

class NoEnvironmentConfig extends EnvironmentConfig {
  @override
  String get environment => "";
  @override
  String get baseUrl => "";
  @override
  String get elasticEntryEndpointPath => "";
  @override
  String get midtransSnapUrl => "";
}