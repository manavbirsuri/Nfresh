import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpdateAddressBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _addressFetcher = PublishSubject<ResponseProfile>();
  Observable<ResponseProfile> get profileData => _addressFetcher.stream;

  fetchData(address, city, area) async {
    var auth = await _prefs.getAuthCode();
    ResponseProfile itemModel = await _repository.updateAddress(auth, address, city, area);
    _addressFetcher.sink.add(itemModel);
  }

  dispose() {
    _addressFetcher.close();
  }
}
