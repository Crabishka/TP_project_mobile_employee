import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app.dart';
import '../../../model/domain/order.dart';
import '../../../model/domain/order_DTO.dart';
import '../../../model/domain/product.dart';
import '../../widgets/progress_order_bar.dart';
import 'order_info.dart';

class QrPaymentPage extends StatefulWidget {
  OrderDTO orderDTO;

  QrPaymentPage({super.key, required this.orderDTO});

  @override
  State<QrPaymentPage> createState() => _QrPaymentPageState();
}

class _QrPaymentPageState extends State<QrPaymentPage> {
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
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 30),
                    child: QrImageView(
                      padding: const EdgeInsets.all(30),
                      data:
                          "https://1469629-cm31020.tw1.ru/bank/go/${widget.orderDTO.order.id}",
                      backgroundColor: Colors.white,
                    ),
                  )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: widget.orderDTO.order.products.length,
                        (context, index) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: Text(widget.orderDTO.order
                                      .products[index].description.title)),
                              Expanded(
                                  flex: 2,
                                  child: Text(formPricePerProduct(
                                      widget.orderDTO.order.products[index]))),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  formTotalPricePerProduct(
                                      widget.orderDTO.order.products[index]),
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
                          const Expanded(flex: 5, child: Text("Итого")),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  formPriceForOrder(widget.orderDTO.order))),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formTotalPrice(widget.orderDTO.order),
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
                            backgroundColor: const Color(0xFF3EB489),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: ifFinished() ? finish() : makePayment(),
                        child: Text(ifFinished() ? "Домой" : "Оплачено",
                            style: const TextStyle(

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
      ),
    );
  }

  VoidCallback makePayment() {
    return () {
      getIt.get<OrderRepository>().payOrder(widget.orderDTO.order.id).then(
        (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderInfo(code: widget.orderDTO.order.id.toString())),
          );
        },
      );
    };
  }

  VoidCallback finish() {
    return () {
      App.changeIndex(1);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => App()),
      );
    };
  }

  bool ifFinished() {
    return widget.orderDTO.order.status == OrderStatus.FINISHED;
  }

  String formTotalPrice(Order order) {
    return '${order.finishTime.difference(order.startTime).inMinutes * order.sum ~/ 60}';
  }

  String formPriceForOrder(Order order) {
    return '${order.sum.toString()}x${order.finishTime.difference(order.startTime).inHours}:${order.finishTime.difference(order.startTime).inMinutes % 60}';
  }

  String formPricePerProduct(Product product) {
    return '${product.description.price.toString()}x${widget.orderDTO.order.finishTime.difference(widget.orderDTO.order.startTime).inHours}:${widget.orderDTO.order.finishTime.difference(widget.orderDTO.order.startTime).inMinutes % 60}';
  }

  String formTotalPricePerProduct(Product product) {
    return '${widget.orderDTO.order.finishTime.difference(widget.orderDTO.order.startTime).inMinutes * product.description.price ~/ 60}';
  }
}
