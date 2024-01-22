import 'environment_config.dart';

class ProdEnvironmentConfig extends EnvironmentConfig {
  @override
  String get environment => "prod";
  @override
  String get baseUrl => "https://8cf6-2404-8000-1004-91e2-75b6-a98d-e05c-6f07.ngrok-free.app/v1/mobile/";
  @override
  String get elasticEntryEndpointPath => "entry";
  @override
  String get midtransSnapUrl => "https://app.midtrans.com/snap/v2/vtweb/";
}