import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoading {

  BuildContext get context => Get.context!;
  bool _isFullScreenLoading = false;

  // this is where you would do your fullscreen loading
  void showFullScreenLoading({Function? onCancel}) {
    _isFullScreenLoading = true;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            const Opacity(opacity: 0.9),
            Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [BoxShadow(offset: const Offset(0.0, -8.0), blurRadius: 8.0, color: Colors.black.withOpacity(0.1))]),
                    width: 80,
                    height: 80,
                    child: const Center(child: CircularProgressIndicator()))),
            if (onCancel != null) Positioned(
                top: 56,
                right: 16,
                child: GestureDetector(
                  onTap: () => onCancel(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )),
          ],
        );
      },
    );
  }

  void hideFullScreenLoading() {
    if (_isFullScreenLoading) {
      Get.back();
      _isFullScreenLoading = false;
    }
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text(error.toString()),
      ),
    );
  }

  Future<void> showInternalError() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: const Text('Internal error'),
      ),
    );
  }
}