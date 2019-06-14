import 'package:nfresh/models/product_model.dart';
import 'package:nfresh/resources/database.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  var _database = DatabaseHelper.instance;
  final _cartProductsFetcher = PublishSubject<List<Product>>();

  Observable<List<Product>> get catProductsList => _cartProductsFetcher.stream;

  fetchData() async {
    List<Product> itemModel = await _database.queryAllProducts();
    _cartProductsFetcher.sink.add(itemModel);
  }

  dispose() {
    _cartProductsFetcher.close();
  }
}
