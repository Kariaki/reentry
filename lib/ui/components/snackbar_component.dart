import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';

class SnackBarComponent extends StatelessWidget {

  const SnackBarComponent(
      {super.key, required this.message, this.error = false,this.info=false});
  final String message;
  final bool info;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 56,
        width: kIsWeb?450:double.infinity,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color:info?Colors.grey: (error ? Colors.red : Colors.green)),
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 8,
          bottom: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Row(
                  children: [
                    Icon(
                      error||info?Icons.error: Icons.check_circle,
                      color: Colors.white,
                    ),
                    10.width,
                    Text(
                      message,
                      style: const TextStyle(
                          fontSize: 16
                      )
                          .copyWith(color: Colors.white),
                    )
                  ],
                )),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 56,
                  color: Colors.white.withOpacity(.3),
                ),
                10.width,
                const  Icon(
                  Icons.close,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
