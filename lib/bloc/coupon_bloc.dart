import 'package:nfresh/models/responses/response_coupons.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CouponBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _couponsFetcher = PublishSubject<ResponseCoupons>();
  Observable<ResponseCoupons> get couponsList => _couponsFetcher.stream;

  fetchData() async {
    var auth = await _prefs.getAuthCode();
    ResponseCoupons itemModel = await _repository.getCoupons(auth);
    _couponsFetcher.sink.add(itemModel);
  }

  dispose() {
    _couponsFetcher.close();
  }
}
