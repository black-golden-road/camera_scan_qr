
import 'camera_scan_qr_platform_interface.dart';

class CameraScanQr {
  Future<String?> getPlatformVersion() {
    return CameraScanQrPlatform.instance.getPlatformVersion();
  }
}
