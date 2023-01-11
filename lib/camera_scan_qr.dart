import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'camera_scan_qr_android/camera_scan_qr_surface_android.dart';
import 'camera_scan_qr_cupertino/camera_scan_qr_cupertino.dart';
import 'camera_scan_qr_platform_interface/camera_scan_qr_platform_interface.dart';

typedef CameraScanQrCreatedCallback = void Function(
    CameraScanQrController controller);

typedef CameraScanQrStringCallback = void Function(String?);

class CameraScanQr extends StatefulWidget {
  const CameraScanQr({
    Key? key,
    this.onResult,
    this.onCameraScanQrCreated,
    this.gestureRecognizers,
  }) : super(key: key);

  static CameraScanQrPlatform? _platform;

  static set platform(CameraScanQrPlatform? platform) {
    _platform = platform;
  }

  static CameraScanQrPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = SurfaceAndroidCameraScanQr();
          break;
        case TargetPlatform.iOS:
          _platform = CupertinoCameraScanQr();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default webview implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform!;
  }

  final CameraScanQrCreatedCallback? onCameraScanQrCreated;

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  final CameraScanQrStringCallback? onResult;

  @override
  State<StatefulWidget> createState() => _CameraScanQrState();
}

class _CameraScanQrState extends State<CameraScanQr> {
  final Completer<CameraScanQrController> _controller =
      Completer<CameraScanQrController>();

  late _PlatformCallbacksHandler _platformCallbacksHandler;

  @override
  Widget build(BuildContext context) {
    return CameraScanQr.platform.build(
      context: context,
      onCameraScanQrPlatformCreated: _onCameraScanQrPlatformCreated,
      cameraScanQrPlatformCallbacksHandler: _platformCallbacksHandler,
      gestureRecognizers: widget.gestureRecognizers,
      creationParams: _creationParamsfromWidget(widget),
    );
  }

  @override
  void initState() {
    super.initState();
    _platformCallbacksHandler = _PlatformCallbacksHandler(widget);
  }

  @override
  void didUpdateWidget(CameraScanQr oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.future.then((CameraScanQrController controller) {
      _platformCallbacksHandler._widget = widget;
      controller._updateWidget(widget);
    });
  }

  void _onCameraScanQrPlatformCreated(
      CameraScanQrPlatformController? platform) {
    final CameraScanQrController controller = CameraScanQrController._(
      widget,
      platform!,
    );
    _controller.complete(controller);
    if (widget.onCameraScanQrCreated != null) {
      widget.onCameraScanQrCreated!(controller);
    }
  }
}

CreationParams _creationParamsfromWidget(CameraScanQr widget) {
  return const CreationParams();
}

class _PlatformCallbacksHandler
    implements CameraScanQrPlatformCallbacksHandler {
  _PlatformCallbacksHandler(this._widget);

  CameraScanQr _widget;

  @override
  void onResult(String? result) {
    if (_widget.onResult != null) {
      _widget.onResult!(result);
    }
  }
}

class CameraScanQrController {
  CameraScanQrController._(
    this._widget,
    this._cameraScanQrPlatformController,
  );

  final CameraScanQrPlatformController _cameraScanQrPlatformController;

  CameraScanQr _widget;

  Future<void> _updateWidget(CameraScanQr widget) async {
    _widget = widget;
  }

  Future<String?> scanImage(String path) {
    return _cameraScanQrPlatformController.scanImage(path);
  }

  void start() {
    _cameraScanQrPlatformController.start();
  }

  void pause() {
    _cameraScanQrPlatformController.pause();
  }

  void resume() {
    _cameraScanQrPlatformController.resume();
  }
}
