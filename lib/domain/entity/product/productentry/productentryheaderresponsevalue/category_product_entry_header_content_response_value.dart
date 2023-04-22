import 'product_entry_header_content_response_value.dart';

class DynamicProductEntryHeaderContentResponseValue extends ProductEntryHeaderContentResponseValue {
  String dynamicBannerImageUrl;
  String title;

  DynamicProductEntryHeaderContentResponseValue({
    required this.dynamicBannerImageUrl,
    required this.title
  });
}