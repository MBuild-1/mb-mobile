// class ProductBrandDetailPage extends RestorableGetxPage<_ProductBrandDetailPageRestoration> {
//   late final ControllerMember<ProductBrandDetailController> _productBrandDetailController = ControllerMember<ProductBrandDetailController>().addToControllerManager(controllerManager);
//
//   final ProductBrandDetailPageParameter productBrandDetailPageParameter;
//
//   ProductBrandDetailPage({
//     Key? key,
//     required this.productBrandDetailPageParameter
//   }) : super(key: key, pageRestorationId: () => "product-brand-page");
//
//   @override
//   void onSetController() {
//     _productBrandDetailController.controller = GetExtended.put<ProductBrandDetailController>(
//       ProductBrandDetailController(
//         controllerManager,
//         Injector.locator<GetProductBrandDetailPagingUseCase>(),
//         Injector.locator<GetSelectedFashionBrandsPagingUseCase>(),
//         Injector.locator<GetSelectedBeautyBrandsPagingUseCase>()
//       ),
//       tag: pageName
//     );
//   }
//
//   @override
//   _ProductBrandPageRestoration createPageRestoration() => _ProductBrandPageRestoration();
//
//   @override
//   Widget buildPage(BuildContext context) {
//     return _StatefulProductBrandControllerMediatorWidget(
//       productBrandController: _productBrandController.controller,
//       productBrandPageParameter: productBrandPageParameter
//     );
//   }
// }
//
// class _ProductBrandPageRestoration extends ExtendedMixableGetxPageRestoration with ProductEntryPageRestorationMixin, SearchPageRestorationMixin {
//   @override
//   // ignore: unnecessary_overrides
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   // ignore: unnecessary_overrides
//   void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
//     super.restoreState(restorator, oldBucket, initialRestore);
//   }
//
//   @override
//   // ignore: unnecessary_overrides
//   void dispose() {
//     super.dispose();
//   }
// }
//
// class ProductBrandPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
//   final ProductBrandPageParameter productBrandPageParameter;
//
//   ProductBrandPageGetPageBuilderAssistant({
//     required this.productBrandPageParameter
//   });
//
//   @override
//   GetPageBuilder get pageBuilder => (() => ProductBrandPage(productBrandPageParameter: productBrandPageParameter));
//
//   @override
//   GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductBrandPage(productBrandPageParameter: productBrandPageParameter)));
// }
//
// mixin ProductBrandPageRestorationMixin on MixableGetxPageRestoration {
//   late ProductBrandPageRestorableRouteFuture productBrandPageRestorableRouteFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     productBrandPageRestorableRouteFuture = ProductBrandPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-brand-route'));
//   }
//
//   @override
//   void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
//     super.restoreState(restorator, oldBucket, initialRestore);
//     productBrandPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     productBrandPageRestorableRouteFuture.dispose();
//   }
// }
//
// class ProductBrandPageRestorableRouteFuture extends GetRestorableRouteFuture {
//   late RestorableRouteFuture<void> _pageRoute;
//
//   ProductBrandPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
//     _pageRoute = RestorableRouteFuture<void>(
//       onPresent: (NavigatorState navigator, Object? arguments) {
//         return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
//       },
//     );
//   }
//
//   static Route<void>? _getRoute([Object? arguments]) {
//     if (arguments is! String) {
//       throw MessageError(message: "Arguments must be a String");
//     }
//     ProductBrandPageParameter productBrandPageParameter = arguments.toProductBrandPageParameter();
//     return GetExtended.toWithGetPageRouteReturnValue<void>(
//       GetxPageBuilder.buildRestorableGetxPageBuilder(
//         ProductBrandPageGetPageBuilderAssistant(productBrandPageParameter: productBrandPageParameter)
//       ),
//     );
//   }
//
//   @pragma('vm:entry-point')
//   static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
//     return _getRoute(arguments)!;
//   }
//
//   @override
//   bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;
//
//   @override
//   void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);
//
//   @override
//   void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
//     restorator.registerForRestoration(_pageRoute, restorationId);
//   }
//
//   @override
//   void dispose() {
//     _pageRoute.dispose();
//   }
// }