import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpdatePhone2Bloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _phoneFetcher = PublishSubject<ResponseProfile>();
  Observable<ResponseProfile> get phoneData => _phoneFetcher.stream;

  fetchData(phone) async {
    var auth = await _prefs.getAuthCode();
    ResponseProfile itemModel = await _repository.updatePhone2(auth, phone);
    _phoneFetcher.sink.add(itemModel);
  }

  dispose() {
    _phoneFetcher.close();
  }
}
