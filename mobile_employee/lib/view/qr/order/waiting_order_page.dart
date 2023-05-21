import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/model/domain/order.dart';

import '../../widgets/product_little_card.dart';
import '../order_info.dart';

class WaitingOrderPage extends StatefulWidget {
  WaitingOrderPage({super.key, required this.order});

  Order order;

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
                SliverToBoxAdapter(
                  child: Text(
                    "Заказ на ${DateFormat('dd-MMM').format(widget.order.date)}",
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: isToday() ? Colors.black : Colors.red,
                        fontFamily: 'PoiretOne',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.order.products.length,
                      (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ProductLittleCard(
                          product: widget.order.products[index],
                        ));
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: isToday() ? () {
                setState(() {
                  getIt.get<OrderRepository>().approve(widget.order.id);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderInfo(code: widget.order.id.toString())),
                  );
                });
              } : null,
              child: Text(isToday() ? "Подтвердить" : "Заказ не на сегодняшную дату :(",
                  style: TextStyle(
                    color: isToday() ?  Colors.cyanAccent : Colors.red,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  bool isToday(){
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime orderDate = DateTime(widget.order.date.year, widget.order.date.month, widget.order.date.day);
    return orderDate == today;
  }

}
