import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'tracking_status_result.dart';

class SuccessTrackingStatusResult extends TrackingStatusResult {
  TrackingStatus trackingStatus;

  SuccessTrackingStatusResult({
    required this.trackingStatus
  });
}