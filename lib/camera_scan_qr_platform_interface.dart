import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'camera_scan_qr_method_channel.dart';

abstract class CameraScanQrPlatform extends PlatformInterface {
  /// Constructs a CameraScanQrPlatform.
  CameraScanQrPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraScanQrPlatform _instance = MethodChannelCameraScanQr();

  /// The default instance of [CameraScanQrPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraScanQr].
  static CameraScanQrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraScanQrPlatform] when
  /// they register themselves.
  static set instance(CameraScanQrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
