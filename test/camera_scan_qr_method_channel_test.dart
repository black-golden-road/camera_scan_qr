import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera_scan_qr/camera_scan_qr_method_channel.dart';

void main() {
  MethodChannelCameraScanQr platform = MethodChannelCameraScanQr();
  const MethodChannel channel = MethodChannel('camera_scan_qr');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
