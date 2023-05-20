import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../viewmodel/app_data.dart';
import '../../viewmodel/token_helper.dart';
import '../domain/order.dart';

class OrderRepository {
  GetIt getIt = GetIt.instance;

  OrderRepository() {
    mainUrl = getIt<AppData>().getUrl();
    urlForGetUserOrder = "$mainUrl/employee/orders";
  }

  String mainUrl = "";
  String urlForGetUserOrder = "";

  Future<Order> getOrderById(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForGetUserOrder/$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      Order order = Order.fromJson(decodedJson);
      return order;
    } else {
      throw ('not found');
    }
  }
}
