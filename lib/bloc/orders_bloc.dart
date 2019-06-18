import 'package:nfresh/models/responses/response_order.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _ordersFetcher = PublishSubject<ResponseOrderHistory>();

  Observable<ResponseOrderHistory> get ordersList => _ordersFetcher.stream;

  fetchOrdersData() async {
    var auth = await _prefs.getAuthCode();
    ResponseOrderHistory itemModel = await _repository.getOrders(auth);
    _ordersFetcher.sink.add(itemModel);
  }

  dispose() {
    _ordersFetcher.close();
  }
}
