import 'give_delivery_review_value.dart';

class ThreeRatingGiveDeliveryReviewValue extends GiveDeliveryReviewValue {
  String _unsatisfiedFeedback;
  String _combinedOrderId;
  String _countryId;
  List<String> _attachmentFilePath;

  ThreeRatingGiveDeliveryReviewValue({
    required String unsatisfiedFeedback,
    required String combinedOrderId,
    required String countryId,
    required List<String> attachmentFilePath
  }) : _unsatisfiedFeedback = unsatisfiedFeedback,
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
  int get rating => 3;

  @override
  String get review => _unsatisfiedFeedback;

  @override
  set review(String value) => _unsatisfiedFeedback = value;

  @override
  List<String> get attachmentFilePath => _attachmentFilePath;

  @override
  set attachmentFilePath(List<String> value) => _attachmentFilePath = value;
}