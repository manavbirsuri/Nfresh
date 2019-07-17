import 'package:nfresh/models/model_checkinventory.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CheckInventoryBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _inventoryFetcher = PublishSubject<ModelInventory>();
  Observable<ModelInventory> get inventory => _inventoryFetcher.stream;

  fetchData(map) async {
    var auth = await _prefs.getAuthCode();
    ModelInventory itemModel = await _repository.checkInventory(auth, map);
    _inventoryFetcher.sink.add(itemModel);
  }

  dispose() {
    _inventoryFetcher.close();
  }
}
