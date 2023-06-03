import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/model/domain/order.dart';
import 'package:mobile_employee/view/qr/order/fitting_order_page.dart';

import '../../../model/domain/order_DTO.dart';
import '../../widgets/product_little_card.dart';
import '../../widgets/progress_order_bar.dart';
import 'order_info.dart';

class WaitingOrderPage extends StatefulWidget {
  WaitingOrderPage({super.key, required this.orderDTO});

  OrderDTO orderDTO;

  @override
  State<WaitingOrderPage> createState() => _WaitingOrderPageState();
}

class _WaitingOrderPageState extends State<WaitingOrderPage> {
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Заказ клиента № ${widget.orderDTO.order.id}",
                      style: const TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 32),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                SliverToBoxAdapter(
                    child: ProgressOrderBar(order: widget.orderDTO.order)),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Заказ от ${DateFormat('dd-MM').format(widget.orderDTO.order.date)} числа",
                          style: const TextStyle(
                              color: Color(0xAA000000),

                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          "Имя: ${widget.orderDTO.name}",
                          style: const TextStyle(
                              color: Color(0xAA000000),

                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          "Телефон: ${widget.orderDTO.phoneNumber}",
                          style: const TextStyle(
                              color: Color(0xAA000000),

                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.orderDTO.order.products.length,
                      (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ProductLittleCard(
                          product: widget.orderDTO.order.products[index],
                        ));
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: isToday()
                      ? const Color(0xFF3EB489)
                      : const Color(0xFFb43e69),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: isToday()
                  ? () {
                      setState(() {
                        waitAccept();
                      });
                    }
                  : null,
              child: Text(
                  isToday() ? "Подтвердить" : "Заказ не на сегодняшную дату :(",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,

                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> waitAccept() async {
    getIt
        .get<OrderRepository>()
        .approve(widget.orderDTO.order.id)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderInfo(
                  code: widget.orderDTO.order.id.toString(),
                )),
      );
    });
  }

  bool isToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime orderDate = DateTime(widget.orderDTO.order.date.year,
        widget.orderDTO.order.date.month, widget.orderDTO.order.date.day);
    return orderDate == today;
  }
}
