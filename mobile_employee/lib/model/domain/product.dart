


import 'package:mobile_employee/model/domain/product_description.dart';

class Product {
  final int id;
  final ProductDescription description;
  final double size;

  Product({required this.id, required this.description, required this.size});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      description: ProductDescription.fromJson(json['productProperty']),
      size: json['size'].toDouble(),
    );
  }
}

