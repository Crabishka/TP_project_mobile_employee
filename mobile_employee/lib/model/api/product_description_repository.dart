import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../viewmodel/app_data.dart';
import '../domain/product_description.dart';
import '../domain/product_size_dto.dart';




class ProductDescriptionRepository {
  GetIt getIt = GetIt.instance;

  ProductDescriptionRepository() {
    mainUrl = getIt<AppData>().getUrl();
    mainUrlForGetProducts = "$mainUrl/products_property";
    mainUrlForGetSizes = "$mainUrl/products/size";
  }

  Future<List<ProductDescription>> getAllProductDescription() {
    return getAllProductDescriptionByRequest();
  }

  String mainUrl = "";
  String mainUrlForGetProducts = "";
  String mainUrlForGetSizes = "";

  Future<List<ProductDescription>> getAllProductDescriptionByRequest() async {
    var url = Uri.parse(mainUrlForGetProducts);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      List<ProductDescription> productList = [];

      for (var item in jsonData) {
        var product = ProductDescription.fromJson(item);
        productList.add(product);
      }

      return productList;
    } else {
      print('Ошибка HTTP: ${response.statusCode}');
      return [];
    }
  }

  Future<ProductSizeDTO> getSizeByDate(DateTime date, int id) async {
    var baseUrl = Uri.parse(mainUrlForGetSizes);

    var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    var zonedDateTime = formatter.format(date);
    var queryParams = {"date": zonedDateTime, "product_id": id.toString()};
    var url = baseUrl.replace(queryParameters: queryParams);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var productSizes = ProductSizeDTO.fromJson(jsonData['map']);

      return productSizes;
    } else {
      print('Ошибка HTTP: ${response.statusCode}');
      return ProductSizeDTO(map: {});
    }
  }
}
