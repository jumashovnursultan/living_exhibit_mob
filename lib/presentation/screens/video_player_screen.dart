import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  Video360Controller? controller;
  bool isDialogOpen = true;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isDialogOpen) {
        loading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Video360View(
        onVideo360ViewCreated: (controller) async {
          this.controller = controller;
          this.controller?.play();
        },
        isRepeat: true,
        url: widget.videoUrl,
        onPlayInfo: (Video360PlayInfo info) {
          if (info.isPlaying && isDialogOpen) {
            isDialogOpen = false;
            Navigator.of(context).pop();
          } else if (!info.isPlaying && info.duration != 8452) {
            if (!isDialogOpen) {
              isDialogOpen = true;
              loading();
            }
          } else if (!info.isPlaying && info.duration == 8452) {
            controller?.play();
          }
        },
      ),
    );
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context)
              ..pop()
              ..pop();
            return false;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator.adaptive(
                  strokeAlign: 1.2,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
