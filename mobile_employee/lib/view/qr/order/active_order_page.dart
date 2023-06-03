import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/domain/order.dart';
import 'package:mobile_employee/view/qr/order/order_info.dart';
import 'package:mobile_employee/view/qr/order/qr_payment_page.dart';
import 'package:mobile_employee/view/widgets/progress_order_bar.dart';

import '../../../app.dart';
import '../../../model/api/order_repository.dart';
import '../../../model/domain/order_DTO.dart';
import '../../widgets/order_product_cart.dart';
import '../../widgets/product_little_card.dart';

class ActiveOrderPage extends StatefulWidget {
  OrderDTO orderDTO;

  ActiveOrderPage({super.key, required this.orderDTO});

  @override
  State<ActiveOrderPage> createState() => _ActiveOrderPageState();
}

class _ActiveOrderPageState extends State<ActiveOrderPage> {
  GetIt getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: TextButton(
            child: const Text(
              "Домой",
              style: TextStyle(

                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              App.changeIndex(1);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App()));
            },
          ),
          backgroundColor: const Color(0xFF3EB489),
          toolbarHeight: 40,
        ),
        body: SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Заказ от ${DateFormat('dd-MMM').format(widget.orderDTO.order.date)} числа",
                        style: const TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        "Имя: ${widget.orderDTO.name}",
                        style: const TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        "Телефон: ${widget.orderDTO.phoneNumber}",
                        style: const TextStyle(

                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        "Стоимость: ${widget.orderDTO.order.sum} руб/час",
                        style: const TextStyle(
                          color: Colors.black,

                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Время аренды: ${DateTime.now().difference(widget.orderDTO.order.startTime).inHours}:"
                        "${DateTime.now().difference(widget.orderDTO.order.startTime).inMinutes % 60}",
                        style: const TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Итого: ${DateTime.now().difference(widget.orderDTO.order.startTime).inMinutes * widget.orderDTO.order.sum ~/ 60} рублей",
                        style: const TextStyle(

                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: ProductLittleCard(
                          product: widget.orderDTO.order.products[index]));
                }),
              ),
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3EB489),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            onPressed: () {
              setState(() {
                awaitFinish();
              });
            },
            child: const Text("Завершить",
                style: TextStyle(

                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ]),
    ));
  }

  Future<void> awaitFinish() async {
    await getIt
        .get<OrderRepository>()
        .finish(widget.orderDTO.order.id)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrderInfo(code: widget.orderDTO.order.id.toString())),
      );
    });
  }
}
