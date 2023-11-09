import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class _PusherHelperImpl {
  Future<void> initPusherChannels({
    required PusherChannelsFlutter pusherChannelsFlutter,
    void Function(PusherEvent)? onEvent
  }) async {
    await pusherChannelsFlutter.init(
      apiKey: "aec3cf529553db66701a",
      cluster: "ap1",
      onEvent: onEvent,
    );
    await pusherChannelsFlutter.connect();
  }

  String _getChatFirstChannelName(ChatPusherChannelType chatPusherChannelType) {
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

  String _getChatCountChannelName() {
    return "chat-count";
  }

  Future<PusherChannelsFlutter> subscribeChatCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent
  }) async {
    try {
      await pusherChannelsFlutter.subscribe(
        channelName: _getChatCountChannelName(),
        onEvent: onEvent
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeChatCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: _getChatCountChannelName()
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> subscribeChatPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required ChatPusherChannelType chatPusherChannelType,
    required String conversationId,
  }) async {
    try {
      await pusherChannelsFlutter.subscribe(
        channelName: "${_getChatFirstChannelName(chatPusherChannelType)}.$conversationId",
        onEvent: onEvent
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeChatPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required ChatPusherChannelType chatPusherChannelType,
    required String conversationId,
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getChatFirstChannelName(chatPusherChannelType)}.$conversationId",
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  String _getDiscussionFirstChannelName(DiscussionPusherChannelType discussionPusherChannelType) {
    if (discussionPusherChannelType == DiscussionPusherChannelType.discussion) {
      return "product-discussion";
    } else if (discussionPusherChannelType == DiscussionPusherChannelType.subDiscussion) {
      return "product-sub-discussion";
    } else {
      return "";
    }
  }

  Future<PusherChannelsFlutter> subscribeDiscussionPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required DiscussionPusherChannelType discussionPusherChannelType,
    required String productDiscussionId,
  }) async {
    try {
      await pusherChannelsFlutter.subscribe(
        channelName: "${_getDiscussionFirstChannelName(discussionPusherChannelType)}.$productDiscussionId",
        onEvent: onEvent
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeDiscussionPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required DiscussionPusherChannelType discussionPusherChannelType,
    required String productDiscussionId,
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getDiscussionFirstChannelName(discussionPusherChannelType)}.$productDiscussionId",
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  String _getSharedCartFirstChannelName() {
    return "bucket-request";
  }

  Future<PusherChannelsFlutter> subscribeSharedCartPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required String bucketId,
  }) async {
    try {
      await pusherChannelsFlutter.subscribe(
        channelName: "${_getSharedCartFirstChannelName()}.$bucketId"
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeSharedCartPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required String bucketId,
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getSharedCartFirstChannelName()}.$bucketId",
      );
    } catch (e) {
      print("ERROR: $e");
    }
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