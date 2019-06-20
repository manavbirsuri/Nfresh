import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChecksumBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _checksumFetcher = PublishSubject<String>();
  Observable<String> get checksum => _checksumFetcher.stream;

  fetchData(map) async {
    var auth = await _prefs.getAuthCode();
    String itemModel = await _repository.getChecksum(auth, map);
    _checksumFetcher.sink.add(itemModel);
  }

  dispose() {
    _checksumFetcher.close();
  }
}
