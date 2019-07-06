import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CreateOrderBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _orderFetcher = PublishSubject<String>();
  Observable<String> get createOrderResponse => _orderFetcher.stream;

  fetchData(map, cart, paytmRes) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.placeOrder(auth, map, cart, paytmRes);
    _orderFetcher.sink.add(itemModel);
  }

  dispose() {
    _orderFetcher.close();
  }
}
