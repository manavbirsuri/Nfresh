

import 'package:nfresh/models/response_home.dart';

import 'api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  Future<ResponseHome> fetchHomeData() => apiProvider.fetchHomeData();
}
