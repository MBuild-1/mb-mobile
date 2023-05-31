class CountryDeliveryReviewMediaPagingParameter {
  int page;
  int itemEachPageCount;

  CountryDeliveryReviewMediaPagingParameter({
    required this.page,
    this.itemEachPageCount = 15
  });
}