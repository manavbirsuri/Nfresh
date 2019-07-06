import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _passwordFetcher = PublishSubject<String>();
  Observable<String> get passwordData => _passwordFetcher.stream;

  fetchData(phone, pass) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.forgotPassword(auth, phone, pass);
    _passwordFetcher.sink.add(itemModel);
  }

  dispose() {
    _passwordFetcher.close();
  }
}
