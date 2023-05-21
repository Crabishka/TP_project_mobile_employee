import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app.dart';
import '../../../model/domain/order.dart';
import '../../../model/domain/product.dart';

class QrPaymentPage extends StatelessWidget {
  Order order;

  QrPaymentPage({super.key, required this.order});

  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 30),
                  child: QrImageView(
                    padding: const EdgeInsets.all(30),
                    data:
                        "https://www.tinkoff.ru/rm/pryadchenko.georgiy1/AMIfa27220",
                    backgroundColor: Colors.white,
                  ),
                )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: order.products.length, (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                    order.products[index].description.title)),
                            Expanded(
                                flex: 1,
                                child: Text(formPricePerProduct(
                                    order.products[index]))),
                            Expanded(
                              flex: 1,
                              child: Text(
                                formTotalPricePerProduct(order.products[index]),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ));
                  }),
                ),
                const SliverToBoxAdapter(
                  child: Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 2,
                    color: Color(0xFF48477D),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text("Итого")),
                        Expanded(
                            flex: 1, child: Text(formPriceForOrder(order))),
                        Expanded(
                          flex: 1,
                          child: Text(
                            formTotalPrice(order),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        getIt.get<OrderRepository>().payOrder(order.id);
                        App.changeIndex(1);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => App()));
                      },
                      child: const Text("Оплачено",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontFamily: 'PoiretOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String formTotalPrice(Order order) {
    return '${DateTime.now().difference(order.startTime).inMinutes * order.sum ~/ 60}';
  }

  String formPriceForOrder(Order order) {
    return '${order.sum.toString()}x${DateTime.now().difference(order.startTime).inHours}:${DateTime.now().difference(order.startTime).inMinutes % 60}';
  }

  String formPricePerProduct(Product product) {
    return '${product.description.price.toString()}x${DateTime.now().difference(order.startTime).inHours}:${DateTime.now().difference(order.startTime).inMinutes % 60}';
  }

  String formTotalPricePerProduct(Product product) {
    return '${DateTime.now().difference(order.startTime).inMinutes * product.description.price ~/ 60}';
  }
}
