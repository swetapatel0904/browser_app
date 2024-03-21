import 'package:flutter/cupertino.dart';
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
        title: SizedBox(
          height: 45,
          child: SearchBar(
            elevation: MaterialStateProperty.resolveWith((states) => 0.5),
              controller: txtWeb,
              hintText: "Search your web address",
              leading: const Icon(Icons.search),
              onTap: () {
                inAppWebViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: WebUri(
                            "https://www.google.com/search?q=${txtWeb!
                                .text}")));
              }),
        ),
        leading: IconButton(
            onPressed: () {
              inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                      url: WebUri("https://www.google.com/search?q")));
              txtWeb!.clear();
            },
            icon: const Icon(Icons.home)),
        actions: [
          IconButton(onPressed: () async {
            String url = (await inAppWebViewController!.getUrl()).toString();
            providerR!.setBookMarks(url);
          }, icon: const Icon(Icons.star_border)),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Backward"),
                onTap: () {
                  inAppWebViewController!.goBack();
                },
              ),
              PopupMenuItem(
                child: Text("Refresh"),
                onTap: () {
                  inAppWebViewController!.reload();
                },
              ),
              PopupMenuItem(
                child: Text("Forward"),
                onTap: () {
                  inAppWebViewController!.goForward();
                },
              ),
              PopupMenuItem(
                onTap: () {
                  providerR!.getBookMarks();
                  showBookMarks();
                },
                child: const Row(
                  children: [
                    Icon(Icons.bookmark),
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
          ? const Center(
          child: Icon(
            Icons.signal_wifi_connected_no_internet_4,
            size: 100,
          ))
          : Column(
        children: [

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
                  providerR!.changeProgress(progress / 100);
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
                pullToRefreshController: pcontroller),
          ),
        ],
      ),
    );
  }

  void showBookMarks() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            Padding(padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(itemCount:providerR!.bookmarksData.length,itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(url: WebUri(providerW!.bookmarksData[index])));
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(providerW!.bookmarksData[index]),));
                    },),
                  ),
                ],
              ),)
    );
  }
}
