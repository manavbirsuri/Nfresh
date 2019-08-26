import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nfresh/resources/api_provider.dart';

class TermAndPrivacy extends StatelessWidget {
  String title;

  var api = ApiProvider();
  var link;
  TermAndPrivacy(String s) {
    this.title = s;
    link = api.baseUrl + "/page_link/4";
//    if (title == "Privacy Policy") {
//      link = api.baseUrl + "/page_link/4";
//    } else {
//      link = api.baseUrl + "/page_link/3";
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: WebviewScaffold(
        url: link,
        appBar: new AppBar(
          title: new Text(
            "$title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        withZoom: true,
        withLocalStorage: true,
      )),
    );
  }
}
