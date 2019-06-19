import 'package:nfresh/models/responses/response_related_products.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class RelatedProductBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _productsFetcher = PublishSubject<ResponseRelatedProducts>();

  Observable<ResponseRelatedProducts> get productsList => _productsFetcher.stream;

  fetchRelatedProducts(prodId) async {
    var auth = await _prefs.getAuthCode();
    ResponseRelatedProducts itemModel = await _repository.getRelatedProducts(auth, prodId);
    _productsFetcher.sink.add(itemModel);
  }

  dispose() {
    _productsFetcher.close();
  }
}
