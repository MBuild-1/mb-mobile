import 'give_delivery_review_value.dart';

class OneRatingGiveDeliveryReviewValue extends GiveDeliveryReviewValue {
  String _disappointedFeedback;
  String _combinedOrderId;
  String _countryId;
  List<String> _attachmentFilePath;

  OneRatingGiveDeliveryReviewValue({
    required String disappointedFeedback,
    required String combinedOrderId,
    required String countryId,
    required List<String> attachmentFilePath
  }) : _disappointedFeedback = disappointedFeedback,
      _combinedOrderId = combinedOrderId,
      _countryId = countryId,
      _attachmentFilePath = attachmentFilePath;

  @override
  String get combinedOrderId => _combinedOrderId;

  @override
  set combinedOrderId(String value) => _combinedOrderId = value;

  @override
  String get countryId => _countryId;

  @override
  set countryId(String value) => _countryId = value;

  @override
  int get rating => 1;

  @override
  String get review => _disappointedFeedback;

  @override
  set review(String value) => _disappointedFeedback = value;

  @override
  List<String> get attachmentFilePath => _attachmentFilePath;

  @override
  set attachmentFilePath(List<String> value) => _attachmentFilePath = value;
}