import 'package:nfresh/models/responses/response_search.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _searchFetcher = PublishSubject<ResponseSearch>();

  Observable<ResponseSearch> get searchedData => _searchFetcher.stream;

  fetchSearchData(searchText) async {
    var auth = await _prefs.getAuthCode();
    ResponseSearch itemModel = await _repository.getSearch(auth, searchText);
    _searchFetcher.sink.add(itemModel);
  }

  dispose() {
    _searchFetcher.close();
  }
}
