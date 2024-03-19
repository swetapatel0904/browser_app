import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerR;
  HomeProvider? providerW;
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController controller = PullToRefreshController();
  TextEditingController txturl=TextEditingController();

  void initState() {
    super.initState();
    context.read<HomeProvider>().changeStatus();
  }

  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("My Browser App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: providerW!.progress,
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri("https://www.google.com")),
              onProgressChanged: (controller, progress) {
                inAppWebViewController = controller;
              },
              onLoadStart: (controller, url) {
                inAppWebViewController = controller;
              },
              onLoadStop: (controller, url) {
                inAppWebViewController = controller;
              },
            ),
          )
        ],
      ),
    );
  }
}
