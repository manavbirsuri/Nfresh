import 'package:nfresh/models/responses/response_otp.dart';
import 'package:nfresh/resources/prefrences.dart';
import 'package:nfresh/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OtpBloc {
  final _repository = Repository();
  final _prefs = SharedPrefs();
  final _otpVerifier = PublishSubject<ResponseOtp>();

  Observable<ResponseOtp> get searchedData => _otpVerifier.stream;

  fetchSearchData(userId, otp) async {
    var auth = await _prefs.getAuthCode();
    ResponseOtp itemModel = await _repository.verifyOtp(auth, userId, otp);
    _otpVerifier.sink.add(itemModel);
  }

  dispose() {
    _otpVerifier.close();
  }
}
