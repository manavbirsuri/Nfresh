import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UpdateWalletBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _walletFetcher = PublishSubject<ResponseProfile>();
  Observable<ResponseProfile> get profileData => _walletFetcher.stream;

  fetchData(amount, resPayTm) async {
    var auth = await _prefs.getAuthCode();
    ResponseProfile itemModel = await _repository.updateWallet(auth, amount, resPayTm);
    _walletFetcher.sink.add(itemModel);
  }

  dispose() {
    _walletFetcher.close();
  }
}
