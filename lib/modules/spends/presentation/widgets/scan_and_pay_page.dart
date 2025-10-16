import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/utils/log_util.dart';
import '../../../../core/widgets/dialogs.dart';
import 'dart:developer' as dev;

import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../data/models/scanned_data.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class ScanAndPayPage extends StatefulWidget {
  const ScanAndPayPage({super.key});

  @override
  State<ScanAndPayPage> createState() => _ScanAndPayPageState();
}

class _ScanAndPayPageState extends State<ScanAndPayPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware{
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,
  );

  StreamSubscription<Object?>? _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
      // Restart the scanner when the app is resumed.
      // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
      case AppLifecycleState.inactive:
      // Stop the scanner when the app is paused.
      // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }




  @override
  void didPush() {
    // TODO: implement didPush
    dev.log('starting the camera 2');
    super.didPush();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() async {
    routeObserver.unsubscribe(this);

    _animationController.dispose();

    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetectError: (error, stck) {
        catchLog(error: error, stck: stck);
      },
      overlayBuilder: (context, constraints) {
        final scanWindowSize = constraints.biggest.shortestSide * 0.7;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Blurred background outside scan window
            ClipPath(
              clipper: _ScanWindowClipper(
                scanWindowSize: Size(scanWindowSize, scanWindowSize),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Scan window with rounded corners
            Center(
              child: CustomPaint(
                size: Size(scanWindowSize, scanWindowSize),
                painter: _ScanWindowPainter(),
              ),
            ),
            // Animated scan line
            Center(
              child: SizedBox(
                width: scanWindowSize,
                height: scanWindowSize,
                child: AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Positioned(
                          top: _scanLineAnimation.value * scanWindowSize,
                          child: Container(
                            width: scanWindowSize,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Instruction text
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Align the QR code within the frame',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      // onDetect: (capture) async {
      //
      // },
    );
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    try {
      final rawValue = capture.barcodes.first.rawValue;
      final uri = Uri.tryParse(rawValue.toString());
      if (uri == null) {
        return;
      }
      dev.log('pausing the camera');
      controller.pause();
      final dataStr = utf8.decode(base64Url.decode(uri.queryParameters['data']!));
      dev.log('data => ${dataStr.runtimeType} => ' +dataStr);
      await AppNav.goRouter.push(RtNm.paymentScreen, extra: ScannedData.fromJson(jsonDecode(dataStr)));
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      showErrorDialog(context: context, message: 'Failed to process the QR code,');
    }
  }

}

class _ScanWindowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final cornerLength = size.width * 0.1;
    final path = Path();

    // Top-left corner
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top-right corner
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom-left corner
    path.moveTo(0, size.height - cornerLength);
    path.lineTo(0, size.height);
    path.lineTo(cornerLength, size.height);

    // Bottom-right corner
    path.moveTo(size.width - cornerLength, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanWindowClipper extends CustomClipper<Path> {
  final Size scanWindowSize;

  _ScanWindowClipper({required this.scanWindowSize});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final scanWindowRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanWindowSize.width,
      height: scanWindowSize.height,
    );

    path.addRect(scanWindowRect);
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
