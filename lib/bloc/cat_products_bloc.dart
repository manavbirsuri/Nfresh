import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CatProductsBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _catProductsFetcher = PublishSubject<ResponseCatProducts>();

  Observable<ResponseCatProducts> get catProductsList =>
      _catProductsFetcher.stream;

  fetchData(catId) async {
    var auth = await _prefs.getAuthCode();
    ResponseCatProducts itemModel =
        await _repository.getCategoryProducts(auth, catId);
    _catProductsFetcher.sink.add(itemModel);
  }

  dispose() {
    _catProductsFetcher.close();
  }
}
