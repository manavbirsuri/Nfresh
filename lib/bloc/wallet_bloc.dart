import 'package:nfresh/models/responses/response_wallet.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _walletFetcher = PublishSubject<ResponseWallet>();
  Observable<ResponseWallet> get walletOffers => _walletFetcher.stream;

  fetchData() async {
    var auth = await _prefs.getAuthCode();
    ResponseWallet itemModel = await _repository.getWalletOffers(auth);
    _walletFetcher.sink.add(itemModel);
  }

  dispose() {
    _walletFetcher.close();
  }
}
