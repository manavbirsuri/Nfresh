import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ApplyCouponBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _responseFetcher = PublishSubject<String>();
  Observable<String> get getResponse => _responseFetcher.stream;

  fetchData(total, couponCode) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.applyCoupon(auth, total, couponCode);
    _responseFetcher.sink.add(itemModel);
  }

  dispose() {
    _responseFetcher.close();
  }
}
