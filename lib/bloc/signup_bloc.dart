import 'package:nfresh/models/responses/response_signup.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _profileSignUp = PublishSubject<ResponseSignUp>();
  Observable<ResponseSignUp> get signUp => _profileSignUp.stream;

  doSignUp(profile) async {
    var auth = await _prefs.getAuthCode();
    ResponseSignUp itemModel = await _repository.getSignUp(auth, profile);
    _profileSignUp.sink.add(itemModel);
  }

  dispose() {
    _profileSignUp.close();
  }
}
