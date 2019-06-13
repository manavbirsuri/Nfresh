import 'package:nfresh/models/responses/response_login.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _profileFetcher = PublishSubject<ResponseLogin>();
  Observable<ResponseLogin> get profileData => _profileFetcher.stream;

  fetchData(phone, password) async {
    var auth = await _prefs.getAuthCode();
    ResponseLogin itemModel = await _repository.getLogin(auth, phone, password);
    _profileFetcher.sink.add(itemModel);
  }

  dispose() {
    _profileFetcher.close();
  }
}
