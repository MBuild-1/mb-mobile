import '../../../../misc/multi_language_string.dart';
import 'order_tracking_location.dart';

class OrderTrackingDetail {
  DateTime timeStamp;
  OrderTrackingLocation orderTrackingLocation;
  MultiLanguageString description;
  List<String> pieceIdList;

  OrderTrackingDetail({
    required this.timeStamp,
    required this.orderTrackingLocation,
    required this.description,
    required this.pieceIdList
  });
}