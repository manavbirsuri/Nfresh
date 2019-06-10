import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: Image.asset(
            'assets/sigbg.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.colorgreen.withOpacity(0.5),
          appBar: AppBar(
            backgroundColor: Colors.colorgreen.withOpacity(0.0),
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.colorlightgreyback,
            child: ListView.builder(itemBuilder: (context, position) {
              return notificationListItem(context, position);
            }),
          ),
        )
      ],
    );
  }

  Widget notificationListItem(BuildContext context, int position) {
    return Card(
      child: Container(
        height: 120,
      ),
    );
  }
}
