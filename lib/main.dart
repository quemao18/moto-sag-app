import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage('https://moto-sag.web.app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.url}) : super(key: key);

 final url;
  MyHomePage(this.url);
  @override
  _MyHomePageState createState() => _MyHomePageState(this.url);
}

class _MyHomePageState extends State<MyHomePage> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  // final Set<String> _favorites = Set<String>();
  var _url;
  final _key = UniqueKey();
  _MyHomePageState(this._url);
  num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
  double statusBarHeight = MediaQuery.of(context).padding.top;
  return Scaffold(
      // appBar: AppBar(),
      body: IndexedStack(
        index: _stackToView,
        children: [
          Container(
          margin: EdgeInsets.only(top: statusBarHeight),
          child:
          Column(
            children: < Widget > [
              Expanded(
                child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: _url,
                  onPageFinished: _handleLoad,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    // webViewController.reload();
                  },
                  navigationDelegate: (NavigationRequest request)
                  {
                    if (request.url.startsWith('https://github.com/quemao18'))
                    {
                      print('blocking navigation to $request}');
                      _launchURL('https://github.com/quemao18');
                      return NavigationDecision.prevent;
                    }

                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                )
              ),
            ],
          ),
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(backgroundColor: Colors.indigo,),
            ),
          ),
        ],
      )
    );
    
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // _bookmarkButton() {
  //   return FutureBuilder<WebViewController>(
  //     future: _controller.future,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<WebViewController> controller) {
  //       if (controller.hasData) {
  //         return FloatingActionButton(
  //           onPressed: () async {
  //             var url = await controller.data.currentUrl();
  //             _favorites.add(url);
  //             Scaffold.of(context).showSnackBar(
  //               SnackBar(content: Text('Saved $url for later reading.')),
  //             );
  //           },
  //           child: Icon(Icons.favorite),
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }
  
}
