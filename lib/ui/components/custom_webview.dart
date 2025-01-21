import 'package:flutter/material.dart';
import 'package:reentry/ui/components/loading_component.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({super.key,});

  //final WebViewController controller;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  var loadingState = 0;

  @override
  void initState() {
    super.initState();
    // widget.controller
    //   ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
    //     setState(() {
    //       loadingState = 0;
    //     });
    //   }, onProgress: (progress) {
    //     if (progress > 10) {
    //       loadingState = 10;
    //     }
    //   }, onPageFinished: (url) {
    //     setState(() {
    //       loadingState = 100;
    //     });
    //   }))
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..addJavaScriptChannel("SnackBar", onMessageReceived: (message) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(message.message)));
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Center();
    // return Stack(children: [
    //   WebViewWidget(
    //     controller: widget.controller,
    //   ),
    //   if (loadingState <5)
    //     Center(
    //       child: LoadingComponent(),
    //     )
    // ]);
  }
}
