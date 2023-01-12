import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:camera_scan_qr/camera_scan_qr.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with AfterLayoutMixin<MyApp>, TickerProviderStateMixin {
  final Completer<CameraScanQrController> _controller =
      Completer<CameraScanQrController>();

  late AnimationController _animateController;

  @override
  void initState() {
    super.initState();
    _animateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: -4,
          toolbarHeight: 44,
          title: const Text(
            'Plugin example app',
            style: TextStyle(color: Colors.white),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: CameraScanQr(
                onCameraScanQrCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            AnimatedBuilder(
              animation: _animateController,
              builder: (context, child) {
                double midY = MediaQuery.of(context).size.height * 0.5;
                double top = midY * 2 / 3 - 64;
                double change = 2 * top;
                return Positioned(
                  top: top + _animateController.value * change,
                  height: 64,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'lib/resources/images/qrcode_scan_full_net.png',
                      width: 375,
                      height: 64,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _controller.future.then((value) {
      value.start();
    });
  }
}
