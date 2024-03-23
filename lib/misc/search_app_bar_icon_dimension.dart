class SearchAppBarDimension {
  double iconButtonSize;
  double get spacingWidth => 10;
  double get iconAreaWidth => iconButtonSize * 3 + spacingWidth;

  SearchAppBarDimension({
    required this.iconButtonSize
  });
}