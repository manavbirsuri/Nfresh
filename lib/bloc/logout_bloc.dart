import 'package:nfresh/models/responses/response_login.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class LogoutBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _phoneFetcher = PublishSubject<ResponseLogin>();
  Observable<ResponseLogin> get phoneData => _phoneFetcher.stream;

  fetchData() async {
    var auth = await _prefs.getAuthCode();
    ResponseLogin itemModel = await _repository.logout(auth);
    _phoneFetcher.sink.add(itemModel);
  }

  dispose() {
    _phoneFetcher.close();
  }
}
