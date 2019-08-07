import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:nfresh/resources/api_provider.dart';

class TermAndPrivacy extends StatelessWidget {
  String title;

  var api = ApiProvider();
  var link;
  TermAndPrivacy(String s) {
    this.title = s;
    if (title == "Privacy Policy") {
      link = api.baseUrl + "/page_link/4";
    } else {
      link = api.baseUrl + "/page_link/3";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: WebviewScaffold(
        url: "https://nfreshonline.com/api/Data_v1/page_link/4",
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
