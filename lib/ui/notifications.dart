import 'package:flutter/material.dart';
import 'package:nfresh/bloc/notifications_bloc.dart';
import 'package:nfresh/models/notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationPage> {
  var bloc = NotificationsBloc();
  var isLoading = true;

  List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    bloc.fetchNotifications();
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
          body: Container(
            color: Colors.colorlightgreyback,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (context, position) {
                      return notificationListItem(context, position);
                    },
                    itemCount: notifications.length,
                  ),
          ),
        )
      ],
    );
  }

  Widget notificationListItem(BuildContext context, int position) {
    var notification = notifications[position];
    return Card(
      child: Container(
        //  height: 120,
        child: ListTile(
          leading: setIcon(notification),
          title: Text(notification.message),
          subtitle: Text(notification.createdAt),
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
            // width: 35,
            // height: 35,
          ),
        );
      case 2:
        return Container(
          // alignment: Alignment.center,
          child: Image.asset(
            "assets/noti_wallet.png",
            // width: 35,
            // height: 35,
          ),
        );
      default:
        return Container(
          // alignment: Alignment.center,
          child: Image.asset(
            "assets/noti_admin.png",
            //  width: 35,
            //  height: 35,
          ),
        );
    }
  }
}
