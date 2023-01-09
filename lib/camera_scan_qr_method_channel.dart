import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_scan_qr_platform_interface.dart';

/// An implementation of [CameraScanQrPlatform] that uses method channels.
class MethodChannelCameraScanQr extends CameraScanQrPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_scan_qr');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
