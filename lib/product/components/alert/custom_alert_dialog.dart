import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/enum/custom_alert_enum.dart';

class CustomAlert {
  static Future<dynamic> customAlert(
      {required BuildContext context,
      required String message,
      required String buttonNo,
      required String buttonYes,
      required CustomAlertType type,
      VoidCallback? onPressedOk,
      VoidCallback? onPressedCansel}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Transform.translate(
                  offset: const Offset(0, -70),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black87,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: type == CustomAlertType.success
                          ? Colors.green
                          : type == CustomAlertType.error
                              ? Colors.red
                              : type == CustomAlertType.warning
                                  ? Colors.orange
                                  : type == CustomAlertType.info
                                      ? Colors.blue
                                      : Colors.blue,
                      child: Icon(
                        type == CustomAlertType.success
                            ? Icons.check_circle
                            : type == CustomAlertType.error
                                ? Icons.error
                                : type == CustomAlertType.warning
                                    ? Icons.warning
                                    : type == CustomAlertType.info
                                        ? Icons.info
                                        : Icons.info,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                actions: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: onPressedCansel ??
                          () {
                            Navigator.pop(context);
                          },
                      child: Text(buttonNo,
                          style: TextStyle(
                            color: type == CustomAlertType.success
                                ? Colors.green
                                : type == CustomAlertType.error
                                    ? Colors.red
                                    : type == CustomAlertType.warning
                                        ? Colors.orange
                                        : type == CustomAlertType.info
                                            ? Colors.blue
                                            : Colors.blue,
                          ))),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: onPressedOk ??
                          () {
                            Navigator.pop(context);
                          },
                      child: Text(
                        buttonYes,
                        style: TextStyle(
                          color: type == CustomAlertType.success
                              ? Colors.green
                              : type == CustomAlertType.error
                                  ? Colors.red
                                  : type == CustomAlertType.warning
                                      ? Colors.orange
                                      : type == CustomAlertType.info
                                          ? Colors.blue
                                          : Colors.blue,
                        ),
                      )),
                ],
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Colors.transparent,
                            child: RichText(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              strutStyle: const StrutStyle(fontSize: 12.0),
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: message,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
