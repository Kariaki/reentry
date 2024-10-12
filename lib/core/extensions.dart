import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/routes/route_map.dart';

extension ContextExtensions on BuildContext {
  dynamic push(Widget route) async {
    final result = await Navigator.push(
      this,
      CupertinoPageRoute(builder: (context) => route),
    );
    return result;
  }

  dynamic pushNames(String name) async {
    final route = RouteMap.maps[name];
    if (route == null) throw Exception('No route find for the given name');
    final result = await push(route);
    return result;
  }

  void pop() {
    Navigator.pop(this);
  }

  void popBack() {
    Navigator.pop(this);
  }

  TextTheme get textTheme => Theme.of(this).textTheme;

  void pushRemoveUntil(Widget route, {dynamic argument}) {
    Navigator.pushAndRemoveUntil(
        this,
        CupertinoPageRoute(builder: (context) => route),
        (Route<dynamic> route) => false);
  }

  void showSnackbar(String message, {bool error = false}) {
    if (message.contains('4')) {
      return;
    }
    if (error) {
      final errorSnack = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        margin: EdgeInsets.only(top: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      );
      ScaffoldMessenger.of(this).showSnackBar(errorSnack);
      return;
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showSnackbarSuccess(String message, {bool success = false}) {
    if (message.contains('4')) {
      return;
    }
    if (success) {
      final successSnack = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      );
      ScaffoldMessenger.of(this).showSnackBar(successSnack);
      return;
    }
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void displayDialog(Widget modal, {bool dismissible = true}) {
    showDialog(
      barrierDismissible: dismissible,
      context: this,
      builder: (context) => AppDialog(
        child: modal,
      ),
    );
  }

  void pushReplace(Widget route) {
    Navigator.pushReplacement(
      this,
      CupertinoPageRoute(builder: (context) => route),
    );
  }

  void pushNameReplacement(String name) {
    final route = RouteMap.maps[name];
    if (route == null) throw Exception('No route find for the given name');
    pushReplace(route);
  }

  void displayDialogDismiss(Widget child) {
    showDialog(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AppDialog(
          child: child,
        );
      },
    );
  }
}

extension IntExtension on int {
  SizedBox get height => SizedBox(
        height: toDouble(),
      );

  SizedBox get width => SizedBox(
        width: toDouble(),
      );
}

extension DoubleExtension on double {
  SizedBox get height => SizedBox(
        height: this,
      );

  SizedBox get width => SizedBox(
        width: this,
      );
}

class AppDialog extends Dialog {
  @override
  final Widget child;

  const AppDialog({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: child);
  }
}
