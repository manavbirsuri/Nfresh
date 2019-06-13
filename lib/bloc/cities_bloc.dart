import 'package:nfresh/models/responses/response_cities.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CityBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _citiesFetcher = PublishSubject<ResponseCities>();
  Observable<ResponseCities> get cities => _citiesFetcher.stream;

  fetchData() async {
    var auth = await _prefs.getAuthCode();
    ResponseCities itemModel = await _repository.getCities(auth);
    _citiesFetcher.sink.add(itemModel);
  }

  dispose() {
    _citiesFetcher.close();
  }
}
