import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpdateProfileBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _profileFetcher = PublishSubject<ResponseProfile>();
  Observable<ResponseProfile> get profileData => _profileFetcher.stream;

  fetchData(name, email) async {
    var auth = await _prefs.getAuthCode();
    ResponseProfile itemModel = await _repository.updateProfile(auth, name, email);
    _profileFetcher.sink.add(itemModel);
  }

  dispose() {
    _profileFetcher.close();
  }
}
