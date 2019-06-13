import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/models/responses/response_cities.dart';
import 'package:nfresh/models/responses/response_coupons.dart';
import 'package:nfresh/models/responses/response_getFavorite.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/models/responses/response_login.dart';
import 'package:nfresh/models/responses/response_otp.dart';
import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/models/responses/response_search.dart';
import 'package:nfresh/models/responses/response_signup.dart';
import 'package:nfresh/models/responses/response_subcat.dart';
import 'package:nfresh/models/responses/response_wallet.dart';

import 'api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  Future<ResponseHome> fetchHomeData() => apiProvider.fetchHomeData();

  Future<ResponseSubCat> getSubCategories(auth, catId) =>
      apiProvider.getSubCategories(auth, catId);

  Future<bool> setFavorite(auth, isFav, productId) =>
      apiProvider.setFavorite(auth, isFav, productId);

  Future<ResponseGetFav> getFavoriteList(auth) =>
      apiProvider.getFavoriteList(auth);

  Future<ResponseCatProducts> getCategoryProducts(auth, catId) =>
      apiProvider.getCatProducts(auth, catId);

  Future<ResponseCoupons> getCoupons(auth) => apiProvider.getCoupons(auth);
  Future<ResponseWallet> getWalletOffers(auth) =>
      apiProvider.getWalletOffers(auth);
  Future<ResponseProfile> getProfile(auth) => apiProvider.getProfile(auth);

  Future<ResponseSearch> getSearch(auth, search) =>
      apiProvider.getSearch(auth, search);
  Future<ResponseSignUp> getSignUp(auth, profile) =>
      apiProvider.getSignUp(auth, profile);

  Future<ResponseLogin> getLogin(auth, phone, password) =>
      apiProvider.getLogin(auth, phone, password);

  Future<ResponseOtp> verifyOtp(auth, userId, otp) =>
      apiProvider.verifyOtp(auth, userId, otp);

  Future<ResponseCities> getCities(auth) => apiProvider.getCities(auth);
}
