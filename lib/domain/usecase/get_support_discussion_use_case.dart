import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/error/not_found_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/discussion/support_discussion.dart';
import '../entity/discussion/support_discussion_parameter.dart';
import '../entity/product/product_detail_parameter.dart';
import '../entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../repository/product_repository.dart';

class GetSupportDiscussionUseCase {
  final ProductRepository productRepository;

  const GetSupportDiscussionUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<SupportDiscussion>> execute(SupportDiscussionParameter supportDiscussionParameter) {
    if (supportDiscussionParameter.productId != null) {
      return productRepository.productDetail(
        ProductDetailParameter(
          productId: supportDiscussionParameter.productId!
        )
      ).map(
        onMap: (value) => value.map<SupportDiscussion>(
          (productDetail) => productDetail
        )
      );
    } else if (supportDiscussionParameter.bundleId != null) {
      return productRepository.productBundleDetail(
        ProductBundleDetailParameter(
          productBundleId: supportDiscussionParameter.bundleId!
        )
      ).map(
        onMap: (value) => value.map<SupportDiscussion>(
          (bundleDetail) => bundleDetail
        )
      );
    }
    return FutureProcessing<LoadDataResult<SupportDiscussion>>(({parameter}) async {
      return FailedLoadDataResult.throwException<SupportDiscussion>(
        () => throw NotFoundError(message: "Support discussion type is not suitable.")
      )!;
    });
  }
}