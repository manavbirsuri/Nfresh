import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _homeFetcher = PublishSubject<ResponseHome>();

  Observable<ResponseHome> get homeData => _homeFetcher.stream;

  fetchHomeData() async {
    var auth = await _prefs.getAuthCode();
    ResponseHome itemModel = await _repository.fetchHomeData(auth);
    var status = itemModel.status;
    if (status == "true") {
      _prefs.setAuthCode(itemModel.authCode);
    }
    _homeFetcher.sink.add(itemModel);
  }

  dispose() {
    _homeFetcher.close();
  }
}
