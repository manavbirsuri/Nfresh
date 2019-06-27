import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpdatePhoneBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _phoneFetcher = PublishSubject<String>();
  Observable<String> get phoneData => _phoneFetcher.stream;

  fetchData(phone) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.updatePhone(auth, phone);
    _phoneFetcher.sink.add(itemModel);
  }

  dispose() {
    _phoneFetcher.close();
  }
}
