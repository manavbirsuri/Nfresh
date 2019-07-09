import 'package:flutter/material.dart';
import 'package:nfresh/bloc/notifications_bloc.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationPage> {
  var bloc = NotificationsBloc();
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    bloc.fetchNotifications();
    bloc.notificationData.listen((res) {
      setState(() {
        isLoading = false;
      });
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
                    itemCount: 20,
                  ),
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
