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

  Future<void> _initPusherChannels({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required void Function(PusherEvent) onEvent
  }) async {
    await pusherChannelsFlutter.init(
      apiKey: "aec3cf529553db66701a",
      cluster: "ap1",
      onEvent: onEvent,
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
      _initPusherChannels(
        pusherChannelsFlutter: pusherChannelsFlutter,
        onEvent: onEvent
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

  Future<PusherChannelsFlutter> connectDiscussionPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required void Function(PusherEvent) onEvent,
    required DiscussionPusherChannelType discussionPusherChannelType,
    required String productDiscussionId,
  }) async {
    String getFirstChannelName() {
      if (discussionPusherChannelType == DiscussionPusherChannelType.discussion) {
        return "product-discussion";
      } else if (discussionPusherChannelType == DiscussionPusherChannelType.subDiscussion) {
        return "product-sub-discussion";
      } else {
        return "";
      }
    }
    try {
      _initPusherChannels(
        pusherChannelsFlutter: pusherChannelsFlutter,
        onEvent: onEvent
      );
      await pusherChannelsFlutter.subscribe(
        channelName: "${getFirstChannelName()}.$productDiscussionId"
      );
      await pusherChannelsFlutter.connect();
    } catch (e) {
      print("ERROR: $e");
    }
    print("kereturn");
    return pusherChannelsFlutter;
  }
}

enum ChatPusherChannelType {
  help, order, product
}

enum DiscussionPusherChannelType {
  discussion, subDiscussion
}

// ignore: non_constant_identifier_names
final _PusherHelperImpl PusherHelper = _PusherHelperImpl();