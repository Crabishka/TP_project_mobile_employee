import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/view/qr/order/qr_payment_page.dart';

import '../../../model/domain/order.dart';

import 'active_order_page.dart';
import 'fitting_order_page.dart';
import 'waiting_order_page.dart';

class OrderInfo extends StatefulWidget {
  OrderInfo({super.key, required String this.code});

  String code;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  GetIt getIt = GetIt.instance;
  late Future<Order> order;

  Future<void> fetchData() async {
    var newOrder =
        await getIt.get<OrderRepository>().getOrderById(int.parse(widget.code));
    setState(() {
      order = Future.value(newOrder);
    });
  }

  @override
  void initState(){
    super.initState();
    order = getIt.get<OrderRepository>().getOrderById(int.parse(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: FutureBuilder<Order>(
        future: order,
        builder: (BuildContext context, AsyncSnapshot<Order> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: const Color(0xFFB6CFD8),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.data == null) {
            return const Center(child: Text("Заказ пуст"));
          } else if (snapshot.data!.status ==
              OrderStatus.WAITING_FOR_RECEIVING) {
            return WaitingOrderPage(order: snapshot.data!);
          } else if (snapshot.data!.status == OrderStatus.ACTIVE) {
            return ActiveOrderPage(order: snapshot.data!);
          } else if (snapshot.data!.status == OrderStatus.FITTING) {
            return FittingOrderPage(order: snapshot.data!);
          } else if (snapshot.data!.status == OrderStatus.WAITING_FOR_PAYMENT) {
            return QrPaymentPage(order: snapshot.data!);
          } else {
            return const Center(
              child: Text("Такого заказа не найдено"),
            );
          }
        },
      ),
    ));
  }
}
