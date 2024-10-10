import 'dart:async';
import 'package:flutter/material.dart';
import 'package:living_exhibit_mob/presentation/scan/barcode_scanner_window.dart';
import 'package:living_exhibit_mob/presentation/scan/scanner_button_widgets.dart';
import 'package:living_exhibit_mob/presentation/scan/scanner_error_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../screens/map_screen.dart';

class BarcodeScannerWithZoom extends StatefulWidget {
  const BarcodeScannerWithZoom({super.key});

  @override
  State<BarcodeScannerWithZoom> createState() => _BarcodeScannerWithZoomState();
}

class _BarcodeScannerWithZoomState extends State<BarcodeScannerWithZoom> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            // fit: BoxFit.contain,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
          _buildScanWindow(scanWindow),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleFlashlightButton(controller: controller),
                      // Expanded(
                      //   child: Center(
                      //     child: ScannedBarcodeLabel(
                      //       barcodes: controller.barcodes,
                      //     ),
                      //   ),
                      // ),
                      SwitchCameraButton(controller: controller),
                      AnalyzeImageFromGalleryButton(controller: controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: MediaQuery.of(context).size.height * 0.5 - 24,
            child: IconButton(
              icon: Image.asset(
                'assets/images/2335353.png',
                height: 20,
                width: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // persistentFooterAlignment: AlignmentDirectional.centerEnd,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Код для перехода на страницу с Google Картой
      //   },
      //   child: Icon(Icons.map),
      // ),
    );
  }

  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
