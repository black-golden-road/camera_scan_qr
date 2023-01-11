import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../camera_scan_qr_platform_interface/camera_scan_qr_platform_interface.dart';
import 'camera_scan_qr_android.dart';

class SurfaceAndroidCameraScanQr extends AndroidCameraScanQr {
  @override
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    CameraScanQrPlatformCreatedCallback? onCameraScanQrPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    required CameraScanQrPlatformCallbacksHandler
        cameraScanQrPlatformCallbacksHandler,
  }) {
    return PlatformViewLink(
      viewType: 'plugins.flutter.io/seewo/pinco/camera_scan_qr',
      surfaceFactory: (
        BuildContext context,
        PlatformViewController controller,
      ) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: 'plugins.flutter.io/seewo/pinco/camera_scan_qr',
          layoutDirection: TextDirection.rtl,
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: creationParams.toJson(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((int id) {
            if (onCameraScanQrPlatformCreated != null) {
              onCameraScanQrPlatformCreated(
                MethodChannelCameraScanQrPlatform(
                    id, cameraScanQrPlatformCallbacksHandler),
              );
            }
          })
          ..create();
      },
    );
  }
}
