import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class _DeeplinkApplinkHelperImpl {
  Uri? _initialURI;
  Uri? get initialURI => _initialURI;

  Uri? _currentURI;
  Uri? get currentURI => _currentURI;

  Object? _err;
  Object? get err => _err;

  bool _initialURILinkHandled = false;
  bool get initialURILinkHandled => _initialURILinkHandled;

  StreamSubscription? _streamSubscription;

  Future<void> initURIHandler({
    required bool Function() mounted,
    required void Function() onSetState
  }) async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          _debugPrint("Initial URI received $initialURI");
          if (!mounted()) {
            return;
          }
          _initialURI = initialURI;
          onSetState();
        } else {
          _debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        _debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted()) {
          return;
        }
        _debugPrint('Malformed Initial URI received');
        _err = err;
        onSetState();
      }
    }
  }

  void incomingLinkHandler({
    required bool Function() mounted,
    required void Function() onSetState
  }) {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted()) {
          return;
        }
        _debugPrint('Received URI: $uri');
        _currentURI = uri;
        _err = null;
        onSetState();
      },
      onError: (Object err) {
        _debugPrint('Error occurred: $err');
        if (!mounted()) {
          return;
        }
        _currentURI = null;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    }
  }

  void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}

// ignore: non_constant_identifier_names
final _DeeplinkApplinkHelperImpl DeeplinkApplinkHelper = _DeeplinkApplinkHelperImpl();