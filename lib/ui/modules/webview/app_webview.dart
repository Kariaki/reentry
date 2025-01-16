import 'package:flutter/cupertino.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
//import 'package:webview_flutter/webview_flutter.dart';

import '../../components/custom_webview.dart';

class AppWebView extends StatefulWidget {
  final String url;
  final String title;

  const AppWebView({super.key, required this.url, required this.title});

  @override
  AppWebViewState createState() => AppWebViewState();
}

class AppWebViewState extends State<AppWebView> {
 // late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    // controller = WebViewController()
    //   ..loadRequest(
    //     Uri.parse(widget.url),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: CustomAppbar(title: widget.title),
        horizontalPadding: 0,
        child: CustomWebView(
         // controller: controller,
        ));
  }
}
