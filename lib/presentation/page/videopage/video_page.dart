import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/videocontroller/video_controller.dart';
import '../../../domain/entity/video/defaultvideo/default_video_paging_parameter.dart';
import '../../../domain/entity/video/shortvideo/short_video_paging_parameter.dart';
import '../../../domain/entity/video/video.dart';
import '../../../domain/usecase/get_short_video_paging_use_case.dart';
import '../../../domain/usecase/get_trip_default_video_paging_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/videolistitemcontrollerstate/video_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/list_item_controller_state_helper.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/string_util.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../getx_page.dart';

class VideoPage extends RestorableGetxPage<_VideoPageRestoration> {
  late final ControllerMember<VideoController> _videoController = ControllerMember<VideoController>().addToControllerManager(controllerManager);

  final VideoPageParameter videoPageParameter;

  VideoPage({Key? key, required this.videoPageParameter}) : super(key: key, pageRestorationId: () => "video-page");

  @override
  void onSetController() {
    _videoController.controller = GetExtended.put<VideoController>(
      VideoController(
        controllerManager,
        Injector.locator<GetTripDefaultVideoPagingUseCase>(),
        Injector.locator<GetShortVideoPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _VideoPageRestoration createPageRestoration() => _VideoPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulVideoControllerMediatorWidget(
      videoController: _videoController.controller,
      videoPageParameter: videoPageParameter,
    );
  }
}

class _VideoPageRestoration extends MixableGetxPageRestoration {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class VideoPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final VideoPageParameter videoPageParameter;

  VideoPageGetPageBuilderAssistant({
    required this.videoPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => VideoPage(videoPageParameter: videoPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(VideoPage(videoPageParameter: videoPageParameter)));
}

mixin VideoPageRestorationMixin on MixableGetxPageRestoration {
  late VideoPageRestorableRouteFuture videoPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    videoPageRestorableRouteFuture = VideoPageRestorableRouteFuture(restorationId: restorationIdWithPageName('video-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    videoPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    videoPageRestorableRouteFuture.dispose();
  }
}

class VideoPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  VideoPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    VideoPageParameter videoPageParameter = arguments.toVideoPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        VideoPageGetPageBuilderAssistant(
          videoPageParameter: videoPageParameter
        )
      )
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulVideoControllerMediatorWidget extends StatefulWidget {
  final VideoController videoController;
  final VideoPageParameter videoPageParameter;

  const _StatefulVideoControllerMediatorWidget({
    required this.videoController,
    required this.videoPageParameter
  });

  @override
  State<_StatefulVideoControllerMediatorWidget> createState() => _StatefulVideoControllerMediatorWidgetState();
}

class _StatefulVideoControllerMediatorWidgetState extends State<_StatefulVideoControllerMediatorWidget> {
  late final ScrollController _videoScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _videoListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _videoListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _videoScrollController = ScrollController();
    _videoListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.videoController.apiRequestManager,
    );
    _videoListItemPagingControllerState = PagingControllerState(
      pagingController: _videoListItemPagingController,
      scrollController: _videoScrollController,
      isPagingControllerExist: false
    );
    _videoListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _videoListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _videoListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _videoListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    VideoPageParameter videoPageParameter = widget.videoPageParameter;
    VideoType videoType = videoPageParameter.videoType;
    late LoadDataResult<PagingDataResult<Video>> videoPagingLoadDataResult;
    if (videoType == VideoType.shortVideo) {
      videoPagingLoadDataResult = await widget.videoController.getShortVideoPaging(
        ShortVideoPagingParameter(page: pageKey)
      );
    } else if (videoType == VideoType.defaultVideo) {
      videoPagingLoadDataResult = await widget.videoController.getDefaultVideoPaging(
        DefaultVideoPagingParameter(page: pageKey)
      );
    }
    return videoPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((videoPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      if (pageKey == 1) {
        resultListItemControllerState = [
          VideoContainerListItemControllerState(
            videoList: videoPaging.itemList,
            onUpdateState: () => setState(() {}),
            onVideoTap: (video) {}
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(orderListItemControllerStateList)) {
          VideoContainerListItemControllerState videoContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(orderListItemControllerStateList![0]) as VideoContainerListItemControllerState;
          videoContainerListItemControllerState.videoList.addAll(videoPaging.itemList);
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: videoPaging.page,
        totalPage: videoPaging.totalPage,
        totalItem: videoPaging.totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text(widget.videoPageParameter.videoType == VideoType.shortVideo ? "Short Video" : "Trip Video"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _videoListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class VideoPageParameter {
  VideoType videoType;

  VideoPageParameter({
    required this.videoType
  });
}

extension VideoPageParameterExt on VideoPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "video_type": videoType == VideoType.shortVideo ? "1" : "2"
    }
  );
}

extension VideoPageParameterStringExt on String {
  VideoPageParameter toVideoPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return VideoPageParameter(
      videoType: result["video_type"] == "1" ? VideoType.shortVideo : VideoType.defaultVideo
    );
  }
}

enum VideoType {
  shortVideo, defaultVideo
}