import 'give_delivery_review_value.dart';

class TwoRatingGiveDeliveryReviewValue extends GiveDeliveryReviewValue {
  String _dissatisfiedFeedback;
  String _combinedOrderId;
  String _countryId;
  List<String> _attachmentFilePath;

  TwoRatingGiveDeliveryReviewValue({
    required String dissatisfiedFeedback,
    required String combinedOrderId,
    required String countryId,
    required List<String> attachmentFilePath
  }) : _dissatisfiedFeedback = dissatisfiedFeedback,
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
  int get rating => 2;

  @override
  String get review => _dissatisfiedFeedback;

  @override
  set review(String value) => _dissatisfiedFeedback = value;

  @override
  List<String> get attachmentFilePath => _attachmentFilePath;

  @override
  set attachmentFilePath(List<String> value) => _attachmentFilePath = value;
}