import 'package:nfresh/models/responses/response_cat_products.dart';
import 'package:nfresh/models/responses/response_cities.dart';
import 'package:nfresh/models/responses/response_coupons.dart';
import 'package:nfresh/models/responses/response_getFavorite.dart';
import 'package:nfresh/models/responses/response_home.dart';
import 'package:nfresh/models/responses/response_login.dart';
import 'package:nfresh/models/responses/response_order.dart';
import 'package:nfresh/models/responses/response_order_detail.dart';
import 'package:nfresh/models/responses/response_otp.dart';
import 'package:nfresh/models/responses/response_profile.dart';
import 'package:nfresh/models/responses/response_related_products.dart';
import 'package:nfresh/models/responses/response_reorder.dart';
import 'package:nfresh/models/responses/response_search.dart';
import 'package:nfresh/models/responses/response_signup.dart';
import 'package:nfresh/models/responses/response_subcat.dart';
import 'package:nfresh/models/responses/response_wallet.dart';

import 'api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  Future<ResponseHome> fetchHomeData(auth, String firebaseToken) =>
      apiProvider.fetchHomeData(auth, firebaseToken);

  Future<ResponseSubCat> getSubCategories(auth, catId) => apiProvider.getSubCategories(auth, catId);

  Future<bool> setFavorite(auth, isFav, productId) =>
      apiProvider.setFavorite(auth, isFav, productId);

  Future<ResponseGetFav> getFavoriteList(auth) => apiProvider.getFavoriteList(auth);

  Future<ResponseCatProducts> getCategoryProducts(auth, catId) =>
      apiProvider.getCatProducts(auth, catId);

  Future<ResponseCoupons> getCoupons(auth) => apiProvider.getCoupons(auth);
  Future<ResponseWallet> getWalletOffers(auth) => apiProvider.getWalletOffers(auth);
  Future<ResponseProfile> getProfile(auth) => apiProvider.getProfile(auth);

  Future<ResponseSearch> getSearch(auth, search) => apiProvider.getSearch(auth, search);
  Future<ResponseSignUp> getSignUp(auth, profile) => apiProvider.getSignUp(auth, profile);

  Future<ResponseLogin> getLogin(auth, phone, password) =>
      apiProvider.getLogin(auth, phone, password);

  Future<ResponseOtp> verifyOtp(auth, userId, otp) => apiProvider.verifyOtp(auth, userId, otp);

  Future<ResponseCities> getCities(auth) => apiProvider.getCities(auth);
  Future<ResponseOrderHistory> getOrders(auth) => apiProvider.getOrdersHistory(auth);
  Future<ResponseOrderDetail> getOrderDetail(auth, orderId) =>
      apiProvider.getOrderDetail(auth, orderId);
  Future<ResponseRelatedProducts> getRelatedProducts(auth, proId) =>
      apiProvider.getRelatedProducts(auth, proId);
  Future<String> getChecksum(auth, map) => apiProvider.getPayTmChecksum(auth, map);
  Future<String> checkInventory(auth, map) => apiProvider.checkInventory(auth, map);
  Future<String> placeOrder(auth, map, cart, paytmRes) =>
      apiProvider.placeOrder(auth, map, cart, paytmRes);
  Future<ResponseReorder> reorder(auth, orderId) => apiProvider.reOrder(auth, orderId);
  Future<String> applyCoupon(auth, total, couponCode) =>
      apiProvider.applyCoupon(auth, total, couponCode);

  Future<ResponseProfile> updateWallet(auth, total, resPayTm) =>
      apiProvider.updateWallet(auth, total, resPayTm);
  Future<ResponseProfile> updateAddress(auth, address, city, area) =>
      apiProvider.updateAddress(auth, address, city, area);
  Future<ResponseProfile> updateProfile(auth, name, email) =>
      apiProvider.updateProfile(auth, name, email);
  Future<String> updatePassword(auth, oldPass, newPass) =>
      apiProvider.updatePassword(auth, oldPass, newPass);
  Future<String> updatePhone(auth, phone) => apiProvider.updatePhone(auth, phone);
  Future<ResponseProfile> updatePhone2(auth, phone) => apiProvider.updatePhone2(auth, phone);
  Future<ResponseLogin> logout(auth) => apiProvider.logout(auth);
  Future<String> forgotPassword(auth, phone, pass) => apiProvider.forgotPassword(auth, phone, pass);
  Future<String> getNotifications(auth, dateTime) => apiProvider.getNotifications(auth, dateTime);
}
