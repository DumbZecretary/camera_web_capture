import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWebCaptureApp extends StatefulWidget {
  const CameraWebCaptureApp({required this.cameras, Key? key})
      : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraWebCaptureApp> createState() => _CameraWebCaptureAppState();
}

class _CameraWebCaptureAppState extends State<CameraWebCaptureApp> {
  CameraController? controller;
  OverlayEntry? sticky;
  GlobalKey stickyKey = GlobalKey();
  double? constSize;

  @override
  void initState() {
    // if use this way, we should sticky?.remove() when navigating
    // if (sticky != null) {
    //   sticky!.remove();
    // }
    // sticky = OverlayEntry(
    //   builder: (context) => stickyBuilder(context),
    // );
    //
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Overlay.of(context)?.insert(sticky!);
    // });
    super.initState();
    if (widget.cameras != null) {
      controller = CameraController(widget.cameras!.last, ResolutionPreset.low);
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              debugPrint('User denied camera access.');
              break;
            default:
              debugPrint('Handle other errors.');
              break;
          }
        }
      });
    } else {
      debugPrint("Can not get any camera");
    }
  }

  Widget stickyBuilder(BuildContext context) {
    return Builder(builder: (context) {
      debugPrint("should render stickyBuilder");
      final keyContext = stickyKey.currentContext;
      if (keyContext != null) {
        // widget is visible
        final box = keyContext.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);
        final h = box.size.height;
        debugPrint("height stickyBuilder is $h");
      } else {
        debugPrint("null stickyBuilder");
      }
      return const SizedBox.shrink();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    sticky?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double? newSize = MediaQuery.of(context).size.width;
    // if (newSize != constSize) {
    // final keyContext_2 = stickyKey.currentContext;
    // if (keyContext_2 != null) {
    //   // widget is visible
    //   final box_2 = keyContext_2.findRenderObject() as RenderBox;
    //   final pos = box_2.localToGlobal(Offset.zero);
    //   final h_2 = box_2.size.height;
    //   debugPrint("height resize is $newSize");
    // } else {
    //   debugPrint("null resize");
    // }
    // setState(() {
    //   constSize = newSize;
    //   debugPrint("Set new size");
    // });
    // }
    return Center(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                constraints: const BoxConstraints(
                  maxWidth: 900,
                  minWidth: 400,
                  // maxHeight: 500,
                  // minHeight: 300,
                ),
                child: FutureBuilder(
                  future: delayTimeToInstallCamera(
                    cameras: widget.cameras,
                    controller: controller,
                  ),
                  builder: (context, data) {
                    if (data.hasData && data.data == 1 && controller != null) {
                      debugPrint(
                        widget.cameras?.length.toString(),
                      );
                      return AspectRatio(
                        aspectRatio: controller!.value.aspectRatio,
                        child: CameraPreview(
                          controller!,
                          key: stickyKey,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              stickyBuilder(context),
            ],
          ),
        ),
      ),
    );
  }
}

Future delayTimeToInstallCamera({
  required List<CameraDescription>? cameras,
  CameraController? controller,
}) async {
  if (controller?.value.aspectRatio != null) {
    debugPrint("install");
    return 1;
  }
  // else {
  //   if (cameras != null) {
  //     debugPrint("Re install");
  //     await controller?.initialize();
  //   }
  // }
  return 0;
}
