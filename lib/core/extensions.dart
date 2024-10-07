import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void pushAnimate(Widget route) {
    Navigator.push(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.5, 1.5);
          const end = Offset.zero;
          const curve = Curves.elasticIn;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(
            tween,
          );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  dynamic push(Widget route) async {
    final result = await Navigator.push(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(
            tween,
          );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
    return result;
  }

  void pop() {
    Navigator.pop(this);
  }

  void popBack() {
    Navigator.pop(this);
  }

  void pushRemoveUntil(Widget route, {dynamic argument}) {
    Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => route,
          settings: RouteSettings(
            arguments: argument,
          ),
        ),
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(
            tween,
          );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
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
