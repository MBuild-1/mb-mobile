class CreateProductDiscussionParameter {
  String? productId;
  String? bundleId;
  String message;

  CreateProductDiscussionParameter({
    this.productId,
    this.bundleId,
    required this.message
  });
}