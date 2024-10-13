import 'dart:async';
import 'package:flutter/material.dart';
import 'package:living_exhibit_mob/presentation/scan/barcode_scanner_window.dart';
import 'package:living_exhibit_mob/presentation/scan/scanner_button_widgets.dart';
import 'package:living_exhibit_mob/presentation/scan/scanner_error_widget.dart';
import 'package:living_exhibit_mob/presentation/screens/video_player_screen.dart';
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
  void initState() {
    super.initState();

    controller.start();

    controller.addListener(() async {
      final barcodes = controller.barcodes;
      final barcode = await barcodes.first;
      // print(barcode.raw);
      // print(barcode.image);
      // print(barcode.size);
      // print(barcodes);

      // if (mounted && barcode.barcodes.first.displayValue != null) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => VideoPlayerScreen(
      //         videoUrl: barcode.barcodes.first.displayValue!,
      //       ),
      //     ),
      //   );
      // }
    });
  }

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
            onDetect: (v) {
              print(v.barcodes.map((e) => e.calendarEvent?.description));
              print(v.barcodes.map((e) => e.calendarEvent?.summary));
              print(v.barcodes.map((e) => e.calendarEvent?.status));
              print(v.barcodes.map((e) => e.calendarEvent?.organizer));
              print(v.barcodes.map((e) => e.contactInfo?.title));
              print(v.barcodes.map((e) => e.contactInfo?.urls));
              print(v.barcodes.map((e) => e.corners));
              print(v.barcodes.map((e) => e.displayValue));
              print(v.barcodes.map((e) => e.format.name));
              print(v.barcodes.map((e) => e.rawBytes));
              print(v.barcodes.map((e) => e.rawValue));
              print(v.barcodes.map((e) => e.url?.title));
              print(v.barcodes.map((e) => e.url?.url));
              print(v.barcodes.map((e) => e.wifi?.encryptionType));
              print(v.barcodes.map((e) => e.wifi?.password));
              print(v.barcodes.map((e) => e.wifi?.ssid));
            },
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
            right: -15,
            top: MediaQuery.of(context).size.height * 0.5 - 24,
            child: IconButton(
              icon: Image.asset(
                'assets/images/2335353.png',
                height: 30,
                width: 30,
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
