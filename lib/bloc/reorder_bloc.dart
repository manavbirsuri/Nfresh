import 'package:nfresh/models/responses/response_reorder.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ReorderBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _reorderFetcher = PublishSubject<ResponseReorder>();

  Observable<ResponseReorder> get reorderedData => _reorderFetcher.stream;

  fetchSearchData(orderId) async {
    var auth = await _prefs.getAuthCode();
    ResponseReorder itemModel = await _repository.reorder(auth, orderId);
    _reorderFetcher.sink.add(itemModel);
  }

  dispose() {
    _reorderFetcher.close();
  }
}
