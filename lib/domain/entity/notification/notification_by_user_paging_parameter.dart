class NotificationByUserPagingParameter {
  int page;
  int itemEachPageCount;
  String? search;

  NotificationByUserPagingParameter({
    required this.page,
    this.itemEachPageCount = 15,
    this.search
  });
}