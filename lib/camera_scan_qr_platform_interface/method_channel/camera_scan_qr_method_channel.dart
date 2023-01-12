import 'package:flutter/services.dart';

import '../platform_interface/platform_interface.dart';

class MethodChannelCameraScanQrPlatform
    implements CameraScanQrPlatformController {
  MethodChannelCameraScanQrPlatform(
    int id,
    this._platformCallbacksHandler,
  ) : _channel =
            MethodChannel('plugins.flutter.io/seewo/pinco/camera_scan_qr_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  final CameraScanQrPlatformCallbacksHandler _platformCallbacksHandler;

  final MethodChannel _channel;

  Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onResult':
        if (call.arguments is Map) {
          Map dict = call.arguments;
          String? result = dict['result'] as String?;
          _platformCallbacksHandler.onResult(result);
        }
        return null;
    }

    throw MissingPluginException(
      '${call.method} was invoked but has no handler',
    );
  }

  @override
  Future<String?> scanImage(String path) async {
    Map? dict = await _channel.invokeMethod<Map>('scanImage', {'path': path});
    if (dict != null) {
      return dict['result'] as String?;
    }
    return null;
  }

  @override
  Future<void> start() async {
    _channel.invokeMethod<Map>('start');
  }

  @override
  Future<void> stop() async {
    _channel.invokeMethod<Map>('stop');
  }
}
