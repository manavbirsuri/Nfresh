import 'dart:convert';

import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';

class ProfileBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  // final _profileFetcher = PublishSubject<ResponseProfile>();
  // Observable<ResponseProfile> get profileData => _profileFetcher.stream;

  fetchData() async {
    var auth = await _prefs.getAuthCode();
    ResponseProfile itemModel = await _repository.getProfile(auth);
    print("Profile Status = " + itemModel.status);
    if (itemModel.status == "true") {
      String profile = jsonEncode(itemModel.profile);
      _prefs.saveProfile(profile);
    }
    //  _profileFetcher.sink.add(itemModel);
  }

  dispose() {
    // _profileFetcher.close();
  }
}
