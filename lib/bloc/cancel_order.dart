import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CancelOrderBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _notificationFetcher = PublishSubject<String>();
  Observable<String> get notificationData => _notificationFetcher.stream;

  cancelOrder(OrderId) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.CancelOrder(auth, OrderId);
    _notificationFetcher.sink.add(itemModel);
  }

  dispose() {
    _notificationFetcher.close();
  }
}
