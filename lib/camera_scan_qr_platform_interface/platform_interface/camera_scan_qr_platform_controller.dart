import 'dart:ffi';

import 'camera_scan_qr_platform_callbacks_handler.dart';

abstract class CameraScanQrPlatformController {
  CameraScanQrPlatformController(CameraScanQrPlatformCallbacksHandler handler);

  Future<String?> scanImage(String path);

  Future<void> start();

  Future<void> pause();

  Future<void> resume();
}
