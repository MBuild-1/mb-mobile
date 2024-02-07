import '../../../../misc/multi_language_string.dart';
import 'order_tracking_location.dart';

class OrderTracking {
  DateTime timeStamp;
  OrderTrackingLocation orderTrackingLocation;
  MultiLanguageString description;
  List<String> pieceIdList;

  OrderTracking({
    required this.timeStamp,
    required this.orderTrackingLocation,
    required this.description,
    required this.pieceIdList
  });
}