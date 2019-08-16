import 'package:flutter/material.dart';
import 'package:nfresh/bloc/notifications_bloc.dart';
import 'package:nfresh/models/notification.dart';
import 'package:toast/toast.dart';

import '../utils.dart';
import 'OrderPage.dart';
import 'WalletPage.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationPage> {
  var bloc = NotificationsBloc();
  var isLoading = true;

  List<NotificationModel> notifications = List();

  @override
  void initState() {
    super.initState();
    Utils.checkInternet().then((connected) {
      if (connected != null && connected) {
        setState(() {
          isLoading = true;
        });
        bloc.fetchNotifications();
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show("Not connected to internet", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });

    bloc.notificationData.listen((res) {
      setState(() {
        isLoading = false;
      });

      if (res.status == "true") {
        setState(() {
          notifications = res.notifications;
        });
      }
    });
  }

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
          body: notifications.length > 0
              ? ListView.builder(
                  itemBuilder: (context, position) {
                    return notificationListItem(context, position);
                  },
                  itemCount: notifications.length,
                )
              : isLoading
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                  : Container(
                      color: Colors.colorlightgreyback,
                      child: Center(
                        child: Text("No Notifications"),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget notificationListItem(BuildContext context, int position) {
    var notification = notifications[position];
    return GestureDetector(
      onTap: () {
        if (notification.sourceType == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WalletPage()));
        } else if (notification.sourceType == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new OrderPage(
                  title: '${notifications[position].sourceId}',
                ),
              ));
        }
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
              child: Row(
            children: <Widget>[
              setIcon(notification),
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            notification.message,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          Text(notification.createdAt),
                        ],
                      )))
            ],
          )
              //  height: 120,
//          child: ListTile(
//            leading: setIcon(notification),
//            title: Text(notification.message),
//            subtitle: Text(notification.createdAt),
//          ),
              ),
        ),
      ),
    );
  }

  Widget setIcon(NotificationModel notification) {
    switch (notification.sourceType) {
      case 1:
        return Container(
          // alignment: Alignment.center,
          child: Image.asset(
            "assets/noti_order.png",
            width: 45,
            height: 45,
          ),
        );
      case 2:
        return Container(
          // alignment: Alignment.center,
          child: Image.asset(
            "assets/noti_wallet.png",
            width: 45,
            height: 45,
          ),
        );
      default:
        return Container(
          // alignment: Alignment.center,
          child: Image.asset(
            "assets/noti_admin.png",
            width: 45,
            height: 45,
          ),
        );
    }
  }
}
