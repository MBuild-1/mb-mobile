import '../../../../../domain/entity/delivery/delivery_review.dart';
import '../../../../../domain/entity/user/user.dart';
import '../../../../errorprovider/error_provider.dart';
import '../../../../load_data_result.dart';
import '../../list_item_controller_state.dart';

class WaitingToBeReviewedDeliveryReviewDetailContainerListItemControllerState extends ListItemControllerState {
  List<DeliveryReview> deliveryReviewList;
  void Function() onUpdateState;
  void Function(DeliveryReview, int)? onWaitingToBeReviewedDeliveryReviewTap;
  ErrorProvider errorProvider;
  void Function()? onTapCheckYourContribution;
  ListItemControllerState Function() getCheckYourContributionDeliveryReviewDetailListItemControllerState;
  WaitingToBeReviewedDeliveryReviewDetailContainerStorageListItemControllerState waitingToBeReviewedDeliveryReviewDetailContainerStorageListItemControllerState;
  WaitingToBeReviewedDeliveryReviewDetailContainerInterceptingActionListItemControllerState waitingToBeReviewedDeliveryReviewDetailContainerInterceptingActionListItemControllerState;

  WaitingToBeReviewedDeliveryReviewDetailContainerListItemControllerState({
    required this.deliveryReviewList,
    required this.onUpdateState,
    required this.onWaitingToBeReviewedDeliveryReviewTap,
    required this.errorProvider,
    required this.getCheckYourContributionDeliveryReviewDetailListItemControllerState,
    required this.waitingToBeReviewedDeliveryReviewDetailContainerStorageListItemControllerState,
    required this.waitingToBeReviewedDeliveryReviewDetailContainerInterceptingActionListItemControllerState,
    this.onTapCheckYourContribution
  });
}

abstract class WaitingToBeReviewedDeliveryReviewDetailContainerStorageListItemControllerState extends ListItemControllerState {}

abstract class WaitingToBeReviewedDeliveryReviewDetailContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  ListItemControllerState Function(LoadDataResult<User>)? get onImplementUserLoadDataResult;
}