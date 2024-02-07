import 'product_discussion_item.dart';

class VerticalProductDiscussionItem extends ProductDiscussionItem {
  @override
  double? get itemWidth => null;

  const VerticalProductDiscussionItem({
    super.key,
    required super.productDiscussion,
    required super.isExpanded,
    required super.supportDiscussionLoadDataResult,
    required super.errorProvider,
    super.onProductDiscussionTap
  });
}