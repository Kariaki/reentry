import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/routes/route_map.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/dimens.dart';
import 'package:intl/intl.dart';

import '../ui/components/snackbar_component.dart';

extension ContextExtensions on BuildContext {
  dynamic pushRoute(Widget route) async {
    final result = await Navigator.push(
      this,
      CupertinoPageRoute(builder: (context) => route),
    );
    return result;
  }

  dynamic pushNames(String name) async {
    final route = RouteMap.maps[name];
    if (route == null) throw Exception('No route find for the given name');
    final result = await pushRoute(route);
    return result;
  }

  void showCustomSnackBar(BuildContext context, Widget child) {
    //custom snackbar
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Material(
              child: Material(
                color: Colors.transparent,
                child: child,
              ),
            )));
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => overlayEntry.remove());
  }

  void popRoute({dynamic result}) {
    // if(kIsWeb){
    //
    //   html.window.history.back();
    //   return;
    // }
    Navigator.pop(this, result);
  }

  void popBack() {
    Navigator.pop(this);
  }

  TextTheme get textTheme => Theme.of(this).textTheme;

  Future<void> pushRemoveUntil(Widget route, {dynamic argument}) async {
    await Navigator.pushAndRemoveUntil(
        this,
        CupertinoPageRoute(builder: (context) => route),
        (Route<dynamic> route) => false);
  }

  void showSnackbarError(String message) {

    _showSuccessSnackBar(this, true,message: message);
  }

  void showSnackbarInfo(String message) {

    _showSuccessSnackBar(this, true,message: message,info: true);
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  static void _showSuccessSnackBar(BuildContext context, bool error,
      {String? message,bool info=false}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8, // Adjust as needed
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: SnackBarComponent(
            message: message ?? 'No action',
            info: info,
            onCancelClick: (){

            },

            error: error,

          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      overlayEntry.remove();
    });
  }
  void showSnackbarSuccess(String message, {bool success = true}) {
  _showSuccessSnackBar(this, !success,message: message);
  }

  Future<dynamic> displayDialog(Widget modal, {bool dismissible = true})async {
   final result =  showDialog(
      barrierDismissible: dismissible,
      context: this,
      builder: (context) => AppDialog(

        child: modal,
      ),
    );
   return result;
  }


  void displayAppDialog(Widget dialog) {
    showDialog(
      context: this,
      builder: (_) => dialog,
    );
  }


  void pushReplace(Widget route) {
    Navigator.pushReplacement(
      this,
      CupertinoPageRoute(builder: (context) => route),
    );
  }

  void showModalMax(Widget modal,
      {bool transparent = false, bool dismissible = true}) {
    final mediaQueryData = MediaQuery.of(this).size;
    final radius = Radius.circular(Dimens.modalRadius);
    showModalBottomSheet(
        isDismissible: dismissible,
        backgroundColor: transparent ? Colors.transparent : Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
        context: this,
        constraints: BoxConstraints(
          minWidth: mediaQueryData.width,
        ),
        builder: (context) => modal);
  }

  Future<dynamic> showModal(Widget modal) async{
    final mediaQueryData = MediaQuery.of(this).size;
    final radius = Radius.circular(Dimens.modalRadius);
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
        context: this,
        isScrollControlled: true,
        backgroundColor: AppColors.gray1,
        constraints: BoxConstraints(maxHeight: mediaQueryData.height),
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: modal,
            ));
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

  String toTimeString() {
    // Convert the timestamp to a DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return processDate(dateTime);
  }

  String processDate(DateTime dateTime) {
    for (int i = 0; i < 7; i++) {
      final now = DateTime.now();
      final nowFormat = DateFormat("MMM d y").format(now);
      final dateTimeFormat = DateFormat("MMM d y").format(dateTime);
      if (nowFormat == dateTimeFormat) {
        return dateTime.beautify(withDate: false);
      }
      final subtractedNow =
          DateFormat("MMM d y").format(now.subtract(Duration(days: i)));
      if (dateTimeFormat == subtractedNow) {
        if (i == 1) {
          return 'Yesterday';
        }
        return '${i}d ago';
      }
    }
    return DateFormat("MMM d y").format(dateTime);
  }
}

extension DoubleExtension on double {
  SizedBox get height => SizedBox(
        height: this,
      );

  SizedBox get width => SizedBox(
        width: this,
      );
}

extension StringExtension on String {
  String get capitalize => capitalizeFirst();

  String capitalizeFirst() {
    if (length < 2) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

class AppDialog extends Dialog {
  @override
  final Widget child;

  const AppDialog({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double maxWidth = width/2;
    if(!kIsWeb){
      maxWidth = width;
    }
    return Dialog(
        alignment: Alignment.center,
        backgroundColor: AppColors.gray1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth
          ),
          child: child,
        ));
  }
}

extension DateTimeExtension on DateTime {
  String beautify({bool withDate = true,bool wrap=true}) {
    final result = DateFormat(
      'hh:mm a',
    ).format(
      this,
    );
    final split = result.split(':');
    final numericalValue = int.parse(split[0]);
    String meridian = 'am';
    if (numericalValue >= 12) {
      meridian = 'pm';
    }
    final date = formatDate();
    return '${withDate ? '$date${wrap?'\n':''}' : ''}$result';
  }

  String toDateString() {
    final result = toIso8601String().split('T');
    if (result.isEmpty) {
      return '';
    }
    return result[0];
  }

  String formatDate({String? format}) {
    return DateFormat(format??"MMM d y").format(this);
  }
}
