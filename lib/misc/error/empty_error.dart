class EmptyError extends Error {
  final EmptyErrorType emptyErrorType;

  EmptyError({
    this.emptyErrorType = EmptyErrorType.defaultEmpty
  });
}

enum EmptyErrorType {
  defaultEmpty, addressEmpty, cartEmpty, sendEmpty, transactionEmpty, wishlistEmpty, notificationEmpty
}