import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../domain/entity/video/shortvideo/short_video.dart';
import '../../../misc/constant.dart';
import '../../../misc/string_util.dart';
import '../modified_loading_indicator.dart';
import '../modifiedappbar/modified_app_bar.dart';
import '../modifiedcachednetworkimage/video_modified_cached_network_image.dart';
import 'video_play_indicator.dart';

class ShortVideoItem extends StatelessWidget {
  final ShortVideo shortVideo;

  const ShortVideoItem({
    super.key,
    required this.shortVideo
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(8.0);
    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      elevation: 3,
      child: InkWell(
        onTap: () => Get.to(
          Column(
            children: [
              ModifiedAppBar(),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: _ShortVideoPlayer(shortVideo: shortVideo),
                ),
              )
            ],
          )
        ),
        borderRadius: borderRadius,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: borderRadius
          ),
          child: AspectRatio(
            aspectRatio: Constant.aspectRatioValueShortVideo.toDouble(),
            child: Stack(
              children: [
                VideoModifiedCachedNetworkImage(
                  imageUrl: "https://img.youtube.com/vi/${StringUtil.convertYoutubeLinkUrlToId(shortVideo.url)}/sddefault.jpg"
                ),
                const VideoPlayIndicator()
              ],
            )
          )
        )
      )
    );
  }
}

class _ShortVideoPlayer extends StatefulWidget {
  final ShortVideo shortVideo;

  const _ShortVideoPlayer({
    required this.shortVideo
  });

  @override
  State<_ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<_ShortVideoPlayer> {
  bool _isLoading = true;
  int _progress = 0;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? effectiveUrl = StringUtil.convertYoutubeLinkUrlToId(widget.shortVideo.url);
    String baseUrl = effectiveUrl.isNotEmptyString ? "https://www.youtube.com/shorts/$effectiveUrl" : widget.shortVideo.url;
    String embedUrl = effectiveUrl.isNotEmptyString ? "https://www.youtube.com/embed/$effectiveUrl" : widget.shortVideo.url;
    return IndexedStack(
      index: _isLoading ? 0 : 1,
      children: [
        const Center(
          child: ModifiedLoadingIndicator()
        ),
        WebView(
          initialUrl: baseUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) async {
            _progress = progress;
            setState(() {});
            if (_isLoading && _progress == 100) {
              await _onPageFinishedLoading();
            } else if (!_isLoading) {
              _onPageStartedLoading();
            }
          },
          zoomEnabled: false,
          onPageStarted: (String url) => _onPageStartedLoading(),
          onPageFinished: (String url) async => await _onPageFinishedLoading(),
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            //_webViewController?.
            _webViewController?.loadHtmlString(
              '''<html><head><meta name="viewport" content="width=device-width,initial-scale=1"></head><body><iframe id="youtube-iframe" src="$embedUrl?enablejsapi=1&autoplay=1&fs=0" frameborder="0" style="position:fixed;top:0;left:0;bottom:0;right:0;width:100%;height:100%;border:none;margin:0;padding:0;overflow:hidden;z-index:999999"></iframe><script type="text/javascript">var tag=document.createElement("script");tag.id="iframe-demo",tag.src="https://www.youtube.com/iframe_api";var player,firstScriptTag=document.getElementsByTagName("script")[0];function onYouTubeIframeAPIReady(){player=new YT.Player("youtube-iframe",{events:{onReady:onPlayerReady,onStateChange:onPlayerStateChange}})}function onPlayerReady(e){document.getElementById("existing-iframe-example").style.borderColor="#FF6D00"}function changeBorderColor(e){-1==e||0==e&&Print.postMessage("Ended")}function onPlayerStateChange(e){changeBorderColor(e.data)}firstScriptTag.parentNode.insertBefore(tag,firstScriptTag)</script></body></html>''',
              baseUrl: baseUrl
            );
          },
        ),
      ]
    );
  }

  Future<void> _onPageFinishedLoading() async {
    setState(() => _isLoading = false);
    _webViewController?.scrollTo(0, 0);
  }

  void _onPageStartedLoading() {
    setState(() => _isLoading = true);
  }
}