import '../../../../domain/entity/discussion/support_discussion.dart';
import '../../../../domain/entity/product/product_in_discussion.dart';
import '../../../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../../../domain/entity/product/productdiscussion/product_discussion_user.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

abstract class ProductDiscussionListItemControllerState extends ListItemControllerState {
  ProductDiscussionDetailListItemValue productDiscussionDetailListItemValue;
  bool isExpanded;
  void Function(ProductDiscussion)? onProductDiscussionTap;
  LoadDataResult<SupportDiscussion> supportDiscussionLoadDataResult;
  ErrorProvider errorProvider;

  ProductDiscussionListItemControllerState({
    required this.productDiscussionDetailListItemValue,
    required this.isExpanded,
    this.onProductDiscussionTap,
    required this.supportDiscussionLoadDataResult,
    required this.errorProvider
  });
}

class ProductDiscussionListItemValue {
  ProductDiscussionDetailListItemValue productDiscussionDetailListItemValue;
  bool isExpanded;

  ProductDiscussionListItemValue({
    required this.productDiscussionDetailListItemValue,
    required this.isExpanded
  });
}

class ProductDiscussionDetailListItemValue {
  List<ProductDiscussionDialogListItemValue> productDiscussionDialogListItemValueList;

  ProductDiscussionDetailListItemValue({
    required this.productDiscussionDialogListItemValueList,
  });
}

class ProductDiscussionDialogListItemValue {
  ProductDiscussionDialogContainsListItemValue productDiscussionDialogContainsListItemValue;
  List<ProductDiscussionDialogListItemValue> replyProductDiscussionDialogListItemValueList;
  bool isExpanded;
  bool isLoading;

  ProductDiscussionDialogListItemValue({
    required this.productDiscussionDialogContainsListItemValue,
    required this.replyProductDiscussionDialogListItemValueList,
    required this.isExpanded,
    this.isLoading = false
  });
}

class ProductDiscussionDialogContainsListItemValue {
  String id;
  String? productId;
  String? bundleId;
  String userId;
  String discussion;
  DateTime discussionDate;
  ProductDiscussionUser productDiscussionUser;
  ProductInDiscussion productInDiscussion;

  ProductDiscussionDialogContainsListItemValue({
    required this.id,
    required this.productId,
    required this.bundleId,
    required this.userId,
    required this.discussion,
    required this.discussionDate,
    required this.productDiscussionUser,
    required this.productInDiscussion,
  });
}

abstract class ProductDiscussionListItemValueStorage {}

extension ProductDiscussionDetailListItemValueExt on ProductDiscussionDetailListItemValue {
  ProductDiscussion toProductDiscussion() {
    return ProductDiscussion(
      productDiscussionDialogList: productDiscussionDialogListItemValueList.map(
        (value) => value.toProductDiscussionDialog()
      ).toList(),
    );
  }
}

extension ProductDiscussionDialogListItemValueExt on ProductDiscussionDialogListItemValue {
  ProductDiscussionDialog toProductDiscussionDialog() {
    return productDiscussionDialogContainsListItemValue.toProductDiscussionDialog()
      ..replyProductDiscussionDialogList = replyProductDiscussionDialogListItemValueList.map(
        (replyProductDiscussionDialogListItemValue) => replyProductDiscussionDialogListItemValue.toProductDiscussionDialog()
      ).toList();
  }
}

extension ProductDiscussionExt on ProductDiscussion {
  ProductDiscussionDetailListItemValue toProductDiscussionDetailListItemValue() {
    return ProductDiscussionDetailListItemValue(
      productDiscussionDialogListItemValueList: productDiscussionDialogList.map(
        (value) => value.toProductDiscussionDialogListItemValue()
      ).toList(),
    );
  }
}

extension ProductDiscussionDialogExt on ProductDiscussionDialog {
  ProductDiscussionDialogListItemValue toProductDiscussionDialogListItemValue() {
    return ProductDiscussionDialogListItemValue(
      productDiscussionDialogContainsListItemValue: toProductDiscussionDialogContainsListItemValue(),
      replyProductDiscussionDialogListItemValueList: replyProductDiscussionDialogList.map(
        (productDiscussionDialog) => productDiscussionDialog.toProductDiscussionDialogListItemValue()
      ).toList(),
      isExpanded: false
    );
  }

  ProductDiscussionDialogContainsListItemValue toProductDiscussionDialogContainsListItemValue() {
    return ProductDiscussionDialogContainsListItemValue(
      id: id,
      productId: productId,
      bundleId: bundleId,
      userId: userId,
      discussion: discussion,
      discussionDate: discussionDate,
      productDiscussionUser: productDiscussionUser,
      productInDiscussion: productInDiscussion,
    );
  }
}

extension ProductDiscussionDialogContainsListItemValueExt on ProductDiscussionDialogContainsListItemValue {
  ProductDiscussionDialog toProductDiscussionDialog() {
    return ProductDiscussionDialog(
      id: id,
      productId: productId,
      bundleId: bundleId,
      userId: userId,
      discussion: discussion,
      discussionDate: discussionDate,
      productDiscussionUser: productDiscussionUser,
      productInDiscussion: productInDiscussion,
      replyProductDiscussionDialogList: []
    );
  }
}