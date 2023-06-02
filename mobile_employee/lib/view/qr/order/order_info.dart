import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/view/qr/order/qr_payment_page.dart';

import '../../../model/domain/order.dart';

import '../../../model/domain/order_DTO.dart';
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
  late Future<OrderDTO> order;

  Future<void> fetchData() async {
    var newOrder =
        await getIt.get<OrderRepository>().getOrderById(int.parse(widget.code));
    setState(() {
      order = Future.value(newOrder);
    });
  }

  @override
  void initState() {
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
      child: FutureBuilder<OrderDTO>(
        future: order,
        builder: (BuildContext context, AsyncSnapshot<OrderDTO> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data == null) {
            return const Center(child: Text("Заказ пуст или доступ запрещен"));
          } else if (snapshot.data!.order.status ==
              OrderStatus.WAITING_FOR_RECEIVING) {
            return WaitingOrderPage(orderDTO: snapshot.data!);
          } else if (snapshot.data!.order.status == OrderStatus.ACTIVE) {
            return ActiveOrderPage(orderDTO: snapshot.data!);
          } else if (snapshot.data!.order.status == OrderStatus.FITTING) {
            return FittingOrderPage(orderDTO: snapshot.data!);
          } else if (snapshot.data!.order.status ==
                  OrderStatus.WAITING_FOR_PAYMENT ||
              snapshot.data!.order.status == OrderStatus.FINISHED) {
            return QrPaymentPage(orderDTO: snapshot.data!);
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
