class OrderPagingParameter {
  int page;
  int itemEachPageCount;

  OrderPagingParameter({
    required this.page,
    this.itemEachPageCount = 15
  });
}