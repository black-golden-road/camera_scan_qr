import 'package:flutter_test/flutter_test.dart';
import 'package:camera_scan_qr/camera_scan_qr.dart';
import 'package:camera_scan_qr/camera_scan_qr_platform_interface.dart';
import 'package:camera_scan_qr/camera_scan_qr_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraScanQrPlatform
    with MockPlatformInterfaceMixin
    implements CameraScanQrPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CameraScanQrPlatform initialPlatform = CameraScanQrPlatform.instance;

  test('$MethodChannelCameraScanQr is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCameraScanQr>());
  });

  test('getPlatformVersion', () async {
    CameraScanQr cameraScanQrPlugin = CameraScanQr();
    MockCameraScanQrPlatform fakePlatform = MockCameraScanQrPlatform();
    CameraScanQrPlatform.instance = fakePlatform;

    expect(await cameraScanQrPlugin.getPlatformVersion(), '42');
  });
}
