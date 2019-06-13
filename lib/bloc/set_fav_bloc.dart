import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SetFavBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _favFetcher = PublishSubject<bool>();

  Observable<bool> get favList => _favFetcher.stream;

  fetchData(isFav, productId) async {
    var auth = await _prefs.getAuthCode();
    bool itemModel = await _repository.setFavorite(auth, isFav, productId);
    _favFetcher.sink.add(itemModel);
  }

  dispose() {
    _favFetcher.close();
  }
}
