import 'environment_config.dart';

class ProdEnvironmentConfig extends EnvironmentConfig {
  @override
  String get environment => "prod";
  @override
  String get baseUrl => "https://api.masterbagasi.com/v1/mobile/";
  @override
  String get elasticEntryEndpointPath => "entry_v6";
  @override
  String get midtransSnapUrl => "https://app.midtrans.com/snap/v2/vtweb/";
}