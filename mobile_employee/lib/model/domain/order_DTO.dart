import 'order.dart';

class OrderDTO {
  Order order;
  String phoneNumber;
  String name;

  OrderDTO(
      {required this.order, required this.phoneNumber, required this.name});

  factory OrderDTO.fromJson(Map<String, dynamic> json) {
    return OrderDTO(
      order: Order.fromJson(json['activeOrder']),
      phoneNumber: json['phoneNumber'],
      name: json['name'],
    );
  }
}
