import 'dart:convert';

import 'package:http/http.dart' show Client;
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
import 'package:nfresh/models/responses/response_search.dart';
import 'package:nfresh/models/responses/response_signup.dart';
import 'package:nfresh/models/responses/response_subcat.dart';
import 'package:nfresh/models/responses/response_wallet.dart';
import 'package:nfresh/ui/SignUp.dart';

class ApiProvider {
  Client client = Client();
  final String baseUrl = "http://cloudart.com.au/projects/nfresh//index.php/api/data_v1";

  // Webservice call to fetch home page data
  Future<ResponseHome> fetchHomeData() async {
    Map map = {'device_id': '123456789'};
    final response = await client.post("$baseUrl/homepage", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ResponseHome.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load homepage service');
    }
  }

  // Webservice call to fetch sub categories list
  Future<ResponseSubCat> getSubCategories(auth, catId) async {
    Map map = {'auth_code': auth, 'cat_id': catId};
    final response = await client.post("$baseUrl/getsubcategories", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ResponseSubCat.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getsubcategories service');
    }
  }

  // Webservice call to add product in favorite list
  Future<bool> setFavorite(auth, isFav, productId) async {
    Map map = {'auth_code': auth, 'product_id': productId, 'is_favourite': isFav};
    final response = await client.post("$baseUrl/setfavourite", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      var status = data['status'];
      return status == "true" ? true : false;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load setfavourite service');
    }
  }

  // Webservice call to get favorite list
  Future<ResponseGetFav> getFavoriteList(auth) async {
    Map map = {'auth_code': auth};
    final response = await client.post("$baseUrl/getfavourite", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseGetFav.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getfavourite service');
    }
  }

  // Webservice call to get category products
  Future<ResponseCatProducts> getCatProducts(auth, catId) async {
    Map map = {'auth_code': auth, 'cat_id': catId};
    final response = await client.post("$baseUrl/getcatproducts", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseCatProducts.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getcatproducts service');
    }
  }

  // Webservice call to get coupons list
  Future<ResponseCoupons> getCoupons(auth) async {
    Map map = {
      'auth_code': auth,
    };
    final response = await client.post("$baseUrl/getcoupons", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseCoupons.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getcoupons service');
    }
  }

  // Webservice call to get wallet offers list
  Future<ResponseWallet> getWalletOffers(auth) async {
    Map map = {
      'auth_code': auth,
    };
    final response = await client.post("$baseUrl/getwalletoffers", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseWallet.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getwalletoffers service');
    }
  }

// Webservice call to get user profile
  Future<ResponseProfile> getProfile(auth) async {
    Map map = {'auth_code': auth};
    final response = await client.post("$baseUrl/getprofile", body: map);
    print("PROFILE: " + response.body.toString());
    if (response.statusCode == 200) {
      return ResponseProfile.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getprofile service');
    }
  }

// Webservice call to get searched item
  Future<ResponseSearch> getSearch(auth, text) async {
    Map map = {
      'auth_code': auth,
      'search': text,
    };
    final response = await client.post("$baseUrl/search", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseSearch.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load search service');
    }
  }

  // Webservice call to Register user
  Future<ResponseSignUp> getSignUp(auth, ProfileSend profile) async {
    print(
        "DATA: ${profile.name}: ${profile.email}: ${profile.phone}: ${profile.password}: ${profile.address}: ${profile.city}: ${profile.area}: ${profile.type}");
    Map map = {
      'authcode': auth,
      'name': profile.name,
      'email': profile.email,
      'phone_no': profile.phone,
      'password': profile.password,
      'address': profile.address,
      'city': profile.city.toString(),
      'area': profile.area.toString(),
      'type': profile.type,
    };
    final response = await client.post("$baseUrl/signup", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseSignUp.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load signup service');
    }
  }

// Webservice call to Login user
  Future<ResponseLogin> getLogin(auth, phone, password) async {
    Map map = {
      'authcode': auth,
      'password': password,
      'phone_no': phone,
    };
    final response = await client.post("$baseUrl/login", body: map);
    print("LOGIN: " + response.toString());
    if (response.statusCode == 200) {
      return ResponseLogin.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load login service');
    }
  }

// Webservice call to verify Otp
  Future<ResponseOtp> verifyOtp(auth, userId, otp) async {
    Map map = {
      'authcode': auth,
      'otp': otp,
      'user_id': userId,
    };
    final response = await client.post("$baseUrl/verifyOtp", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseOtp.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load verifyOtp service');
    }
  }

  // Webservice call to get user profile
  Future<ResponseCities> getCities(auth) async {
    Map map = {
      'auth_code': auth,
    };
    final response = await client.post("$baseUrl/getcityarea", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseCities.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getcityarea service');
    }
  }

  // Webservice call to get user profile
  Future<ResponseOrderHistory> getOrdersHistory(auth) async {
    Map map = {
      'auth_code': auth,
    };
    final response = await client.post("$baseUrl/orderhistory", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseOrderHistory.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load orderhistory service');
    }
  }

  Future<ResponseOrderDetail> getOrderDetail(auth, orderId) async {
    Map map = {
      'auth_code': auth,
      'order_id': orderId,
    };
    final response = await client.post("$baseUrl/orderdetail", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseOrderDetail.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load orderdetail service');
    }
  }

  Future<ResponseRelatedProducts> getRelatedProducts(auth, productId) async {
    Map map = {
      'auth_code': auth,
      'product_id': productId,
    };
    final response = await client.post("$baseUrl/getrelatedproducts", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ResponseRelatedProducts.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getrelatedproducts service');
    }
  }

  Future<String> getPayTmChecksum(auth, Map<String, dynamic> data) async {
    Map map = {
      'auth_code': auth,
      'data': jsonEncode(data),
    };
    final response = await client.post("$baseUrl/getchecksum", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load getchecksum service');
    }
  }

  Future<String> checkInventory(auth, List<Map<String, dynamic>> data) async {
    Map map = {
      'auth_code': auth,
      'line_items': jsonEncode(data),
    };
    final response = await client.post("$baseUrl/checkprodinventory", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load checkprodinventory service');
    }
  }

  Future<String> placeOrder(
      auth, List<Map<String, dynamic>> data, Map<String, dynamic> cart) async {
    Map map = {
      'auth_code': auth,
      'line_items': jsonEncode(data),
      'total': cart['total'].toString(),
      'address': cart['address'],
      'city': cart['city'].toString(),
      'area': cart['area'].toString(),
      'type': cart['type'].toString(),
      'discount': cart['discount'].toString(),
    };
    final response = await client.post("$baseUrl/createorder", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('NFresh: Failed to load createorder service');
    }
  }
}
