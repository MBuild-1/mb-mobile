import 'environment_config.dart';

class LocalDevEnvironmentConfig extends EnvironmentConfig {
  @override
  String get environment => "local_dev";
  @override
  String get baseUrl => "http://172.20.134.183:8000/v1/mobile/";
  @override
  String get elasticEntryEndpointPath => "entry_v5";
  @override
  String get midtransSnapUrl => "https://app.sandbox.midtrans.com/snap/v2/vtweb/";
  @override
  String get appleLoginWebUrl => "https://staging.apple-auth.masterbagasi.com/auth/apple";
}