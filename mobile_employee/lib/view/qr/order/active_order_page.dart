import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/domain/order.dart';
import 'package:mobile_employee/view/qr/order/qr_payment_page.dart';

import '../../../model/api/order_repository.dart';
import '../../widgets/order_product_cart.dart';
import '../../widgets/product_little_card.dart';

class ActiveOrderPage extends StatefulWidget {
  Order order;

  ActiveOrderPage({super.key, required this.order});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage> {
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFB6CFD8),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.order.products.length,
                      (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ProductLittleCard(
                            product: widget.order.products[index]));
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Стоимость ${widget.order.sum} руб/час",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Время аренды: ${DateTime.now().difference(widget.order.startTime).inHours}:"
                  "${DateTime.now().difference(widget.order.startTime).inMinutes % 60}",
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Итого: ${DateTime.now().difference(widget.order.startTime).inMinutes * widget.order.sum ~/ 60} рублей",
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
                setState(() {
                  getIt.get<OrderRepository>().finish(widget.order.id);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrPaymentPage(order: widget.order)),
                );
              },
              child: const Text("Завершить",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]));
  }
}
