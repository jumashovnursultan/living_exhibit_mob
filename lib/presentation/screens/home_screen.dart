import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';

// import 'package:qr_code_scanner/qr_code_scanner.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  Video360Controller? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Video360View(
        onVideo360ViewCreated: (controller) {
          this.controller = controller;
        },
        url: 'https://rnvcz-185-117-151-203.a.free.pinggy.link/video',
        onPlayInfo: (Video360PlayInfo info) {
          // print(info.)
          //chyngyzaitmatovexhibit
        },
      ),
    );
  }
}
