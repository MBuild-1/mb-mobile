class DefaultVideoPagingParameter {
  int page;
  int itemEachPageCount;

  DefaultVideoPagingParameter({
    required this.page,
    this.itemEachPageCount = 15
  });
}