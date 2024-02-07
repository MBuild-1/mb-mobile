import 'give_delivery_review_value.dart';
import 'quality_feedback_delivery_review_value.dart';

class FiveRatingGiveDeliveryReviewValue extends GiveDeliveryReviewValue implements QualityFeedbackDeliveryReviewValue {
  String _verySatisfiedFeedback;
  String _combinedOrderId;
  String _countryId;
  List<String> _attachmentFilePath;
  bool _hasServiceQuality;
  bool _hasPackagingQuality;
  bool _hasPriceQuality;
  bool _hasItemQuality;
  bool _hasDeliveryQuality;

  FiveRatingGiveDeliveryReviewValue({
    required String verySatisfiedFeedback,
    required String combinedOrderId,
    required String countryId,
    required List<String> attachmentFilePath,
    required bool hasServiceQuality,
    required bool hasPackagingQuality,
    required bool hasPriceQuality,
    required bool hasItemQuality,
    required bool hasDeliveryQuality
  }) : _verySatisfiedFeedback = verySatisfiedFeedback,
      _combinedOrderId = combinedOrderId,
      _countryId = countryId,
      _attachmentFilePath = attachmentFilePath,
      _hasServiceQuality = hasServiceQuality,
      _hasPackagingQuality = hasPackagingQuality,
      _hasPriceQuality = hasPriceQuality,
      _hasItemQuality = hasItemQuality,
      _hasDeliveryQuality = hasDeliveryQuality;

  @override
  String get combinedOrderId => _combinedOrderId;

  @override
  set combinedOrderId(String value) => _combinedOrderId = value;

  @override
  String get countryId => _countryId;

  @override
  set countryId(String value) => _countryId = value;

  @override
  int get rating => 5;

  @override
  String get review => _verySatisfiedFeedback;

  @override
  set review(String value) => _verySatisfiedFeedback = value;

  @override
  bool get hasServiceQuality => _hasServiceQuality;

  @override
  set hasServiceQuality(bool value) => _hasServiceQuality = value;

  @override
  bool get hasPackagingQuality => _hasPackagingQuality;

  @override
  set hasPackagingQuality(bool value) => _hasPackagingQuality = value;

  @override
  bool get hasPriceQuality => _hasPriceQuality;

  @override
  set hasPriceQuality(bool value) => _hasPriceQuality = value;

  @override
  bool get hasItemQuality => _hasItemQuality;

  @override
  set hasItemQuality(bool value) => _hasItemQuality = value;

  @override
  bool get hasDeliveryQuality => _hasDeliveryQuality;

  @override
  set hasDeliveryQuality(bool value) => _hasDeliveryQuality = value;

  @override
  List<String> get attachmentFilePath => _attachmentFilePath;

  @override
  set attachmentFilePath(List<String> value) => _attachmentFilePath = value;
}