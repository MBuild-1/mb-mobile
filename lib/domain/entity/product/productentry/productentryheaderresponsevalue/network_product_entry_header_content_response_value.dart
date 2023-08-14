import 'product_entry_header_content_response_value.dart';

class NetworkProductEntryHeaderContentResponseValue extends ProductEntryHeaderContentResponseValue {
  String networkImageUrl;
  String title;
  double? aspectRatio;

  NetworkProductEntryHeaderContentResponseValue({
    required this.networkImageUrl,
    required this.title,
    this.aspectRatio
  });
}