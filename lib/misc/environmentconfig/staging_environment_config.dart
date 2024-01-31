import 'environment_config.dart';

class StagingEnvironmentConfig extends EnvironmentConfig {
  @override
  String get environment => "staging";
  @override
  String get baseUrl => "https://staging-api.masterbagasi.com/v1/mobile/";
  @override
  String get elasticEntryEndpointPath => "entry_v5";
  @override
  String get midtransSnapUrl => "https://app.sandbox.midtrans.com/snap/v2/vtweb/";
}