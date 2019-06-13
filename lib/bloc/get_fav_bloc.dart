import 'package:nfresh/models/responses/response_getFavorite.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetFavBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _favFetcher = PublishSubject<ResponseGetFav>();

  Observable<ResponseGetFav> get favList => _favFetcher.stream;

  fetchHomeData() async {
    var auth = await _prefs.getAuthCode();
    ResponseGetFav itemModel = await _repository.getFavoriteList(auth);
    _favFetcher.sink.add(itemModel);
  }

  dispose() {
    _favFetcher.close();
  }
}
