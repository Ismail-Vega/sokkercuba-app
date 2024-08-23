import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  late FToast _fToast;

  ToastService(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  void showToast(String message, {Color backgroundColor = Colors.greenAccent}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info, color: Colors.white),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              softWrap: true,
            ),
          ),
        ],
      ),
    );

    _fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  void showToastWithCloseButton(String message,
      {Color backgroundColor = Colors.redAccent}) {
    Widget toastWithButton = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              message,
              softWrap: true,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _fToast.removeCustomToast();
            },
          )
        ],
      ),
    );

    _fToast.showToast(
      child: toastWithButton,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 50),
    );
  }

  void showQueueOfToasts(List<String> messages) {
    for (String message in messages) {
      _fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.greenAccent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  void cancelToast() {
    _fToast.removeCustomToast();
  }

  void cancelAllToasts() {
    _fToast.removeQueuedCustomToasts();
  }
}
