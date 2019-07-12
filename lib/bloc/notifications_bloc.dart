import 'package:nfresh/models/responses/response_notifications.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _notificationFetcher = PublishSubject<ResponseNotifications>();
  Observable<ResponseNotifications> get notificationData => _notificationFetcher.stream;

  fetchNotifications() async {
    var auth = await _prefs.getAuthCode();
    var dateTime = await _prefs.getDateTime();
    ResponseNotifications itemModel = await _repository.getNotifications(auth, dateTime);
    _notificationFetcher.sink.add(itemModel);
  }

  dispose() {
    _notificationFetcher.close();
  }
}
