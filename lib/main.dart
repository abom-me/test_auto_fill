import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:test_auto_fill/in_app_browser.dart';
// import 'package:url_launcher/url_launcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
      home: new InAppBrowserPage()
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
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
                      // key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse("https://moodle.nct.edu.om/login/index.php")),
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
   var email =document.querySelector('input#username');
            var password = document.querySelector('input#password');
             var button = document.querySelector("#loginbtn");
//            
//
//
// email.removeAttribute("value");

//   password.value = "55221133";
   // button.click();
   
  var emailText = "s22j20264"; // Change this to the desired text


  var emailI = 0;
  var emailInterval = setInterval(function() {
    if (emailI < emailText.length) {
      email.value += emailText.charAt(emailI);
      emailI++;
    } else {
      clearInterval(emailInterval);
      
         
     
          var passwordText = "Ab.om0078"; // Change this to the desired text
  password.focus();
  var passwordI = 0;
  var passwordInterval = setInterval(function() {
    if (passwordI < passwordText.length) {
      password.value += passwordText.charAt(passwordI);
      passwordI++;
    } else {
      clearInterval(passwordInterval);
      button.click();
    }
  }, 100); 
    }
  }, 100); 

  
  //   var passwordText = "nasr@abom.me"; // Change this to the desired text
  // password.focus();
  // var passwordI = 0;
  // var passwordInterval = setInterval(function() {
  //   if (passwordI < passwordText.length) {
  //     password.value += passwordText.charAt(passwordI);
  //     passwordI++;
  //   } else {
  //     clearInterval(passwordInterval);
  //   }
  // }, 100); 
// // button.click();
 
 ''');
                      if(url.toString()=='https://moodle.nct.edu.om/my/'){
                      //  multiline
                      //   document.querySelectorAll(`a[href="${path}"]`);
    await controller.evaluateJavascript(source:'''
   var l= document.querySelector('#groupingdropdown');
   var l2= document.querySelector('a[data-value="inprogress"]');
   var l3= document.querySelector('a[href="https://moodle.nct.edu.om/course/view.php?id=140"]');
   
  l.click();
  setTimeout(function() {
      l2.click();
  }, 1000);
  setTimeout(function() {
     l3.click();
  }, 500);

    ''');
                      }else if(url.toString()=='https://moodle.nct.edu.om/course/view.php?id=140'){
                        await controller.evaluateJavascript(source:'''
 
   var l3= document.querySelector('a[href="https://moodle.nct.edu.om/mod/resource/view.php?id=14460"]');

  // l3.click();

window.scrollTo({
  top: 500,
  left: 0,
  behavior: 'smooth' // 'auto' for instant scrolling
});

  setTimeout(function() {
     l3.click();
  }, 500);
    ''');
                      }else if(url.toString()=='https://moodle.nct.edu.om/pluginfile.php/30790/mod_resource/content/27/UTAS-N12-4-CDP.pdf'){
                        await controller.evaluateJavascript(source:'''
 
alert("You are in the Delivery Plan Now");

    ''');
                      }
                      
                      print(url.toString());
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

class T extends StatelessWidget {
  const T({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>MyApp()));
          },
          child: Text("Start"),
        ),
      ),
    );
  }
}
