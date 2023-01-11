import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../camera_scan_qr_platform_interface/camera_scan_qr_platform_interface.dart';

class AndroidCameraScanQr implements CameraScanQrPlatform {
  @override
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required CameraScanQrPlatformCallbacksHandler
        cameraScanQrPlatformCallbacksHandler,
    CameraScanQrPlatformCreatedCallback? onCameraScanQrPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    return GestureDetector(
      onLongPress: () {},
      excludeFromSemantics: true,
      child: AndroidView(
        viewType: 'plugins.flutter.io/seewo/pinco/camera_scan_qr',
        onPlatformViewCreated: (int id) {
          if (onCameraScanQrPlatformCreated != null) {
            onCameraScanQrPlatformCreated(MethodChannelCameraScanQrPlatform(
                id, cameraScanQrPlatformCallbacksHandler));
          }
        },
        gestureRecognizers: gestureRecognizers,
        layoutDirection: Directionality.maybeOf(context) ?? TextDirection.rtl,
        creationParams: creationParams.toJson(),
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
