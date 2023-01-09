import 'package:flutter/material.dart';

import '../../controller/splash_screen_controller.dart';
import '../../misc/constant.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/manager/controller_manager.dart';
import 'getx_page.dart';
import 'home_page.dart';

class SplashScreenPage extends RestorableGetxPage<_SplashScreenPageRestoration> {
  late final ControllerMember<SplashScreenController> _splashScreenController = ControllerMember<SplashScreenController>().addToControllerManager(controllerManager);

  SplashScreenPage({Key? key}) : super(key: key, pageRestorationId: () => "splash-screen-page");

  @override
  void onSetController() {
    _splashScreenController.controller = GetExtended.put<SplashScreenController>(SplashScreenController(controllerManager), tag: pageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    _splashScreenController.controller.startIntroductionPage(
      onStartHomePage: () {
        Navigator.of(context).popUntil((route) => false);
        getPageRestoration(context).homePageRestorableRouteFuture.present();
      },
    );
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Image.asset(Constant.imageLogoSuperIndo),
          )
        )
      )
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenPageRestoration createPageRestoration() => _SplashScreenPageRestoration();
}

class _SplashScreenPageRestoration extends GetxPageRestoration {
  late HomePageRestorableRouteFuture homePageRestorableRouteFuture;

  @override
  void initState() {
    homePageRestorableRouteFuture = HomePageRestorableRouteFuture(restorationId: 'home-page-route');
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    homePageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    homePageRestorableRouteFuture.dispose();
  }
}