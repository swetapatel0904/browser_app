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
  PullToRefreshController? pcontroller;
  TextEditingController txtWeb = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().changeStatus();
    pcontroller = PullToRefreshController(
      onRefresh: () {
        inAppWebViewController!.reload();
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Browser App"),
        leading: IconButton(
            onPressed: () {
              inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                      url: WebUri("https://www.google.com/search?q")));
              txtWeb!.clear();
            },
            icon: const Icon(Icons.home)),
        actions: [
          IconButton(
              onPressed: () {
                inAppWebViewController!.goBack();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          IconButton(
              onPressed: () {
                inAppWebViewController!.reload();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                inAppWebViewController!.goForward();
              },
              icon: const Icon(Icons.arrow_forward_ios)),
          IconButton(
              onPressed: () {
                providerR!.bookMarks();
              },
              icon: const Icon(Icons.star_border)),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  providerW!.bookMarks();
                },
                child: const Row(
                  children: [
                    Icon(Icons.bookmark_add_outlined),
                    Text("Bookmarks"),
                  ],
                ),
              ),
            ];
          }),
        ],
        centerTitle: true,
      ),
      body: providerR!.isOnline == false
          ? const Center(child: Icon(Icons.signal_wifi_connected_no_internet_4,size: 100,))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SearchBar(
                      controller: txtWeb,
                      hintText: "Search your web address",
                      leading: const Icon(Icons.search),
                      onTap: () {
                        inAppWebViewController?.loadUrl(
                            urlRequest: URLRequest(
                                url: WebUri(
                                    "https://www.google.com/search?q=${txtWeb!.text}")));
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: providerW!.progress,
                ),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: WebUri("https://www.google.com/search?q")),
                    onProgressChanged: (controller, progress) {
                      providerR!.changeProgress(progress/100);
                      inAppWebViewController = controller;
                      if (progress == 100) {
                        pcontroller?.endRefreshing();
                      }
                    },
                    onLoadStart: (controller, url) {
                      inAppWebViewController = controller;
                    },
                    onLoadStop: (controller, url) {
                      pcontroller?.endRefreshing();
                      inAppWebViewController = controller;
                    },
                    pullToRefreshController: pcontroller
                  ),
                ),
              ],
            ),
    );
  }


}
