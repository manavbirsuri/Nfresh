import 'package:nfresh/models/responses/response_order_detail.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _orderDetailFetcher = PublishSubject<ResponseOrderDetail>();

  Observable<ResponseOrderDetail> get orderDetail => _orderDetailFetcher.stream;

  fetchOrderDetail(orderId) async {
    var auth = await _prefs.getAuthCode();
    ResponseOrderDetail itemModel = await _repository.getOrderDetail(auth, orderId);
    _orderDetailFetcher.sink.add(itemModel);
  }

  dispose() {
    _orderDetailFetcher.close();
  }
}
