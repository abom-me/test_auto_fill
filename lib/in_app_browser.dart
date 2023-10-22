import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowserPage extends StatefulWidget {
  const InAppBrowserPage({Key? key}) : super(key: key);

  @override
  State<InAppBrowserPage> createState() => _InAppBrowserPageState();
}

class _InAppBrowserPageState extends State<InAppBrowserPage> {

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: true,
          javaScriptCanOpenWindowsAutomatically:true
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        enableViewportScale:true,
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("test")),
        body: SafeArea(
            child: Column(children: <Widget>[

              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                    
                      implementation: WebViewImplementation.NATIVE,
                      // key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse("https://abom.me/auto-login.html")),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });


                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        // if (![ "http", "https", "file", "chrome",
                        //   "data", "javascript", "about"].contains(uri.scheme)) {
                        //   if (await canLaunch(url)) {
                        //     // Launch the App
                        //     await launch(
                        //       url,
                        //     );
                        //     // and cancel the request
                        //     return NavigationActionPolicy.CANCEL;
                        //   }
                        // }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                        await controller.evaluateJavascript(source:'''
  var email = document.querySelector('input#email');
  const nameInput = document.getElementById("name");
  var password = document.querySelector('input#password');
  var login = document.querySelector('button#login');
  var emailText = "nasr@abom.me";
  var passwordText = "55221133";
  var nameText = "Nasr Al-Rahbi";

  var passwordI = 0;
  var emailI = 0;
  var nameI = 0;
  
  var emailCompleted = false;
  var passwordCompleted = false;
  var nameCompleted = false;

  setTimeout(function() {
    var emailInterval = setInterval(function() {
      if (emailI < emailText.length) {
        email.value += emailText.charAt(emailI);
        emailI++;
      } else {
        clearInterval(emailInterval);
        emailCompleted = true;
        checkCompletion();
      }
    }, 100);
  }, 1000);

  setTimeout(function() {
    var nameInterval = setInterval(function() {
      if (nameI < nameText.length) {
        nameInput.value += nameText.charAt(nameI);
        nameI++;
      } else {
        clearInterval(nameInterval);
        nameCompleted = true;
        checkCompletion();
      }
    }, 100);
  }, 1000);

  setTimeout(function() {
    var passwordInterval = setInterval(function() {
      if (passwordI < passwordText.length) {
        password.value += passwordText.charAt(passwordI);
        passwordI++;
      } else {
        clearInterval(passwordInterval);
        passwordCompleted = true;
        checkCompletion();
      }
    }, 100);
  }, 1000);

  function checkCompletion() {
    if (emailCompleted && nameCompleted && passwordCompleted) {
  
    document.getElementById("login-button").click();
    }
  }
 ''');
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
              // ButtonBar(
              //   alignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     ElevatedButton(
              //       child: Icon(Icons.arrow_back),
              //       onPressed: () {
              //         webViewController?.goBack();
              //       },
              //     ),
              //     ElevatedButton(
              //       child: Icon(Icons.arrow_forward),
              //       onPressed: () {
              //         webViewController?.goForward();
              //       },
              //     ),
              //     ElevatedButton(
              //       child: Icon(Icons.refresh),
              //       onPressed: () {
              //         webViewController?.reload();
              //       },
              //     ),
              //   ],
              // ),
            ]))
    );
  }
}
