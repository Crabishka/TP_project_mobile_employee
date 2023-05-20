import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/model/domain/order.dart';

import '../../widgets/product_little_card.dart';

class WaitingOrderPage extends StatelessWidget {
  WaitingOrderPage({super.key, required this.order});

  GetIt getIt = GetIt.instance;
  final Order order;

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
                    "Ваш заказ на ${DateFormat('dd-MMM').format(order.date)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'PoiretOne',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: order.products.length, (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ProductLittleCard(
                          product: order.products[index],
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
              onPressed: () {
                getIt.get<OrderRepository>().approve(order.id);
              },
              child: const Text("Подтвердить",
                  style: TextStyle(
                    color: Colors.cyanAccent,
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
}
