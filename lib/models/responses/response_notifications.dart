import '../notification.dart';

class ResponseNotifications{
  String status;
  BigInt dateTime;
  List<NotificationModel> notifications = [];

  ResponseNotifications.fromJson(decode) {
    status = decode['status'];
    dateTime = decode['datetime'].toBigInt();
    if (decode['notifications'] != null) {
      for (int i = 0; i < decode['notifications'].length; i++) {
        notifications.add(NotificationModel(decode['notifications'][i]));
      }
    }
  }
}