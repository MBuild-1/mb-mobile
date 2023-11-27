import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class _PusherHelperImpl {
  final Completer<bool> _pusherConnectedCompleter = Completer<bool>();

  Future<void> initPusherChannels({
    required PusherChannelsFlutter pusherChannelsFlutter,
    void Function(PusherEvent)? onEvent
  }) async {
    await pusherChannelsFlutter.init(
      apiKey: "aec3cf529553db66701a",
      cluster: "ap1",
      onEvent: onEvent,
    );
    while (true) {
      try {
        await pusherChannelsFlutter.connect();
        if (kDebugMode) {
          print("Pusher Connected");
        }
        _pusherConnectedCompleter.complete(true);
        break;
      } catch (e) {
        // Repeat until connected
      }
    }
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
    return "chat-count-event";
  }

  Future<PusherChannelsFlutter> subscribeChatCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required String userId
  }) async {
    try {
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
        channelName: "${_getChatCountChannelName()}.$userId",
        onEvent: onEvent
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeChatCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required String userId
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getChatCountChannelName()}.$userId",
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  String _getNotificationCountChannelName() {
    return "notif-count-event";
  }

  Future<PusherChannelsFlutter> subscribeNotificationCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required String userId
  }) async {
    try {
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
        channelName: "${_getNotificationCountChannelName()}.$userId",
        onEvent: onEvent
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }

  Future<PusherChannelsFlutter> unsubscribeNotificationCountPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required String userId
  }) async {
    try {
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getNotificationCountChannelName()}.$userId",
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
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
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
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
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

  String _getSharedCartBucketApprovedChannelName() {
    return "bucket-approved";
  }

  String _getSharedCartBucketCartMirroringChannelName() {
    return "cart-mirroring";
  }

  Future<PusherChannelsFlutter> subscribeSharedCartPusherChannel({
    required PusherChannelsFlutter pusherChannelsFlutter,
    required dynamic Function(dynamic) onEvent,
    required String bucketId,
  }) async {
    try {
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
        channelName: "${_getSharedCartFirstChannelName()}.$bucketId",
        onEvent: onEvent
      );
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
        channelName: "${_getSharedCartBucketApprovedChannelName()}.$bucketId",
        onEvent: onEvent
      );
      await pusherChannelsFlutter.subscribeAfterPusherIsConnected(
        pusherConnectedCompleter: _pusherConnectedCompleter,
        channelName: "${_getSharedCartBucketCartMirroringChannelName()}.$bucketId",
        onEvent: onEvent
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
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getSharedCartBucketApprovedChannelName()}.$bucketId",
      );
      await pusherChannelsFlutter.unsubscribe(
        channelName: "${_getSharedCartBucketCartMirroringChannelName()}.$bucketId",
      );
    } catch (e) {
      print("ERROR: $e");
    }
    return pusherChannelsFlutter;
  }
}

extension on PusherChannelsFlutter {
  Future<PusherChannel> subscribeAfterPusherIsConnected({
    required Completer<bool> pusherConnectedCompleter,
    required String channelName,
    var onSubscriptionSucceeded,
    var onSubscriptionError,
    var onMemberAdded,
    var onMemberRemoved,
    var onEvent,
    var onSubscriptionCount
  }) async {
    await pusherConnectedCompleter.future;
    return await subscribe(
      channelName: channelName,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
      onSubscriptionError: onSubscriptionError,
      onMemberAdded: onMemberAdded,
      onMemberRemoved: onMemberRemoved,
      onEvent: onEvent,
      onSubscriptionCount: onSubscriptionCount
    );
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