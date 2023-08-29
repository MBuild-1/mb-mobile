import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class _PusherHelperImpl {
  Future<PusherChannelsFlutter> generateAndConnectChatPusherChannel({
    required void Function(PusherEvent) onEvent,
    required ChatPusherChannelType chatPusherChannelType,
    required String conversationId
  }) async {
    PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
    return connectChatPusherChannel(
      pusherChannelsFlutter: _pusher,
      onEvent: onEvent,
      chatPusherChannelType: chatPusherChannelType,
      conversationId: conversationId
    );
  }

  Future<PusherChannelsFlutter> connectChatPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required void Function(PusherEvent) onEvent,
    required ChatPusherChannelType chatPusherChannelType,
    required String conversationId,
  }) async {
    String getFirstChannelName() {
      if (chatPusherChannelType == ChatPusherChannelType.help) {
        return "help-messages";
      } else if (chatPusherChannelType == ChatPusherChannelType.order) {
        return "order-messages";
      } else if (chatPusherChannelType == ChatPusherChannelType.product) {
        return "product-messages";
      } else {
        return "";
      }
    }
    try {
      await pusherChannelsFlutter.init(
        apiKey: "aec3cf529553db66701a",
        cluster: "ap1",
        onEvent: onEvent,
      );
      await pusherChannelsFlutter.subscribe(
        channelName: "${getFirstChannelName()}.$conversationId"
      );
      await pusherChannelsFlutter.connect();
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }
}

enum ChatPusherChannelType {
  help, order, product
}

// ignore: non_constant_identifier_names
final _PusherHelperImpl PusherHelper = _PusherHelperImpl();