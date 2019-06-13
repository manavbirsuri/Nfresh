import 'package:nfresh/models/responses/response_subcat.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class SubCatBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _subCatFetcher = PublishSubject<ResponseSubCat>();

  Observable<ResponseSubCat> get subCatData => _subCatFetcher.stream;

  fetchSubCategories(catId) async {
    var auth = await _prefs.getAuthCode();
    ResponseSubCat itemModel = await _repository.getSubCategories(auth, catId);
    _subCatFetcher.sink.add(itemModel);
  }

  dispose() {
    _subCatFetcher.close();
  }
}
