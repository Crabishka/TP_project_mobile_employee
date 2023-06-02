import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../viewmodel/app_data.dart';
import '../../viewmodel/token_helper.dart';
import '../domain/order.dart';
import '../domain/order_DTO.dart';

class OrderRepository {
  GetIt getIt = GetIt.instance;

  OrderRepository() {
    mainUrl = getIt<AppData>().getUrl();
    urlForGetUserOrder = "$mainUrl/employee/orders";
    urlForApproveOrder = "$mainUrl/employee/orders/approve";
    urlForFinishOrder = "$mainUrl/employee/orders/finish";
    urlForGetLastOrders = "$mainUrl/employee/last_orders";
    urlForChangeUserProduct = '$mainUrl/employee/change';
    urlForRemoveUserProduct = '$mainUrl/employee/delete';
    urlForPayOrder = '$mainUrl/employee/orders/pay';
    urlForCancelOrder = '$mainUrl/employee/orders/cancel';
    urlForFindOrderByNumber = '$mainUrl/orders/number';
  }

  String mainUrl = "";
  String urlForGetUserOrder = "";
  String urlForApproveOrder = "";
  String urlForFinishOrder = "";
  String urlForGetLastOrders = "";
  String urlForChangeUserProduct = "";
  String urlForRemoveUserProduct = "";
  String urlForPayOrder = "";
  String urlForCancelOrder = "";
  String urlForFindOrderByNumber = "";

  Future<OrderDTO> getOrderById(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForGetUserOrder/$id');
    var response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {

      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      OrderDTO order = OrderDTO.fromJson(jsonData);
      return order;
    } else {
      throw ('not found');
    }
  }

  Future<void> approve(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForApproveOrder/$id');
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      throw ('not found');
    }
  }

  Future<void> finish(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForFinishOrder/$id');
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      throw ('not found');
    }
  }

  Future<List<OrderDTO>> getLastOrders() async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var baseUrl = Uri.parse(urlForGetLastOrders);
    var response = await http.post(baseUrl,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<OrderDTO> orderList = [];
      for (var item in jsonData) {
        var product = OrderDTO.fromJson(item);
        orderList.add(product);
      }
      return orderList;
    } else {
      return [];
    }
  }

  Future<void> changeSize(
      int orderId, int productId, double size, double newSize) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }

    var url = Uri.parse(
        '$urlForChangeUserProduct/$productId/$orderId/${size.truncate().toString()}/${newSize.truncate().toString()}');

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      print('Ошибка HTTP: ${response.statusCode}');
      throw ('${response.statusCode}');
    }
  }

  Future<void> removeProduct(int orderId, int productId, double size) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var baseUrl = Uri.parse('$urlForRemoveUserProduct/$productId');
    var queryParams = {"order_id": orderId.toString(), "size": size.toString()};
    var url = baseUrl.replace(queryParameters: queryParams);
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      print('Ошибка HTTP: ${response.statusCode}');
      throw ('${response.statusCode}');
    }
  }

  Future<void> payOrder(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForPayOrder/$id');
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      throw ('not found');
    }
  }

  Future<void> cancel(int id) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForCancelOrder/$id');
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
    } else {
      throw ('not found');
    }
  }

  Future<List<OrderDTO>> findOrderByNumber(String phoneNumber) async {
    String? token = await TokenHelper().getUserToken();
    if (token == null ||
        token.isEmpty ||
        getIt.get<TokenHelper>().isTokenExpired(token)) {
      throw ('access denied');
    }
    var url = Uri.parse('$urlForFindOrderByNumber/$phoneNumber');
    var response = await http.get(url,
        headers: {'Content-Type': 'application/json', 'Authorization': token});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<OrderDTO> orderList = [];
      var product = OrderDTO.fromJson(jsonData);
      orderList.add(product);
      return orderList;
    } else {
      return [];
    }
  }
}
