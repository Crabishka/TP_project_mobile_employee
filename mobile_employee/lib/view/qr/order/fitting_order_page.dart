import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/model/domain/order.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../app.dart';
import '../../../model/domain/order_DTO.dart';
import '../../widgets/order_product_cart.dart';
import '../../widgets/progress_order_bar.dart';
import 'order_info.dart';

class FittingOrderPage extends StatefulWidget {
  const FittingOrderPage({super.key, required this.orderDTO});

  final OrderDTO orderDTO;

  @override
  State<FittingOrderPage> createState() => _FittingOrderPageState();
}

class _FittingOrderPageState extends State<FittingOrderPage> {
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
                  fontFamily: 'PoiretOne',
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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          fontFamily: 'PoiretOne',
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
                          "Заказ от ${DateFormat('dd-MMM').format(widget.orderDTO.order.date)} числа",
                          style: const TextStyle(
                              color: Color(0xAA000000),
                              fontFamily: 'PoiretOne',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Text(
                          "Имя: ${widget.orderDTO.name}",
                          style: const TextStyle(
                              color: Color(0xAA000000),
                              fontFamily: 'PoiretOne',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Text(
                          "Телефон: ${widget.orderDTO.phoneNumber}",
                          style: const TextStyle(
                              color: Color(0xAA000000),
                              fontFamily: 'PoiretOne',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Text(
                          "Сумма: ${widget.orderDTO.order.sum.truncate().toString()} руб/час",
                          style: const TextStyle(
                            color: Color(0xAA000000),
                            fontFamily: 'PoiretOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        CountdownTimerWidget(
                            countdownDuration: widget.orderDTO.order.startTime
                                    .difference(DateTime.now()) +
                                const Duration(minutes: 10)),
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
                        child: OrderProductCard(
                            product: widget.orderDTO.order.products[index],
                            order: widget.orderDTO.order));
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFb43e69),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: () {
                setState(() {
                  getIt
                      .get<OrderRepository>()
                      .cancel(widget.orderDTO.order.id)
                      .then((value) {
                    App.changeIndex(1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => App()),
                    );
                  });
                });
              },
              child: const Text("Отменить",
                  style: TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
            ),
          )
        ]));
  }
}

class CountdownTimerWidget extends StatefulWidget {
  final Duration countdownDuration;

  const CountdownTimerWidget({super.key, required this.countdownDuration});

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Duration remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.countdownDuration;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
        });
      }
      if (remainingTime.inSeconds <= 0) {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Время на примерку ${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
      style: const TextStyle(
        color: Color(0xAA000000),
        fontFamily: 'PoiretOne',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
