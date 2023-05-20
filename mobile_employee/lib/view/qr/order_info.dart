import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';

import '../../model/domain/order.dart';

import 'order/active_order_page.dart';
import 'order/fitting_order_page.dart';
import 'order/waiting_order_page.dart';

class OrderInfo extends StatefulWidget {

  OrderInfo({super.key, required String this.code});

  String code;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Order>(
      future: getIt.get<OrderRepository>().getOrderById(int.parse(widget.code)),
      builder: (BuildContext context, AsyncSnapshot<Order> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.status == OrderStatus.WAITING_FOR_RECEIVING) {
          return WaitingOrderPage(order : snapshot.data!);
        } else if (snapshot.data!.status == OrderStatus.ACTIVE) {
          return ActiveOrderPage(snapshot.data!);
        } else if (snapshot.data!.status == OrderStatus.FITTING) {
          return FittingOrderPage(snapshot.data!);
        } else {
          return Center(
            child: Text("Такого заказа не найдено"),
          );
        }
      },
    ));
  }
}
