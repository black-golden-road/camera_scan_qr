import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../types/types.dart';
import 'camera_scan_qr_platform_callbacks_handler.dart';
import 'camera_scan_qr_platform_controller.dart';

typedef CameraScanQrPlatformCreatedCallback = void Function(
    CameraScanQrPlatformController? cameraScanQrPlatformController);

abstract class CameraScanQrPlatform {
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required CameraScanQrPlatformCallbacksHandler
        cameraScanQrPlatformCallbacksHandler,
    CameraScanQrPlatformCreatedCallback? onCameraScanQrPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  });
}
