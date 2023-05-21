import 'package:mobile_employee/model/domain/product.dart';

class Order {
  final int id;
  final List<Product> products;
  final DateTime date;
  final DateTime startTime;
  final DateTime finishTime;
  final double sum;
  final OrderStatus status;

  Order(
      {required this.id,
      required this.products,
      required this.date,
      required this.sum,
      required this.status,
      required this.startTime,
      required this.finishTime,
      });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        products: (json['products'] as List<dynamic>)
            .map((productJson) => Product.fromJson(productJson))
            .toList(),
        date: json['orderTime'] == null
            ? DateTime.now()
            : DateTime.parse(json['orderTime']),
        startTime: json['startTime'] == null
            ? DateTime.now()
            : DateTime.parse(json['startTime']),
        finishTime: json['finishTime'] == null
            ? DateTime.now()
            : DateTime.parse(json['finishTime']),
        sum: json['totalCost'].toDouble(),
        status: OrderStatus.values.firstWhere((element) =>
            element.toString().split('.').last == json['orderStatus']));
  }
}

enum OrderStatus {
  ACTIVE,
  FITTING,
  WAITING_FOR_RECEIVING,
  FINISHED,
  CANCELED_BY_USER,
  CANCELED_BY_EMPLOYEE,
  CARTING,
  WAITING_FOR_PAYMENT
}

extension OrderStatusExtension on OrderStatus {
  String getStatusText() {
    switch (this) {
      case OrderStatus.ACTIVE:
        return "Используется";
      case OrderStatus.FITTING:
        return "Примерка";
      case OrderStatus.WAITING_FOR_RECEIVING:
        return "Ожидает получения";
      case OrderStatus.FINISHED:
        return "Завершён";
      case OrderStatus.CANCELED_BY_USER:
        return "Отменен пользователем";
      case OrderStatus.CANCELED_BY_EMPLOYEE:
        return "Отменен системой";
      case OrderStatus.CARTING:
        return "Выбираются товары";
      case OrderStatus.WAITING_FOR_PAYMENT:
        return "Ожидает оплаты";
      default:
        return "Unknown status";
    }
  }
}
