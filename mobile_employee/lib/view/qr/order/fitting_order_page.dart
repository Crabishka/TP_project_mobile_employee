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
import '../../widgets/order_product_cart.dart';
import '../order_info.dart';

class FittingOrderPage extends StatefulWidget {
  FittingOrderPage({super.key, required this.order});

  final Order order;

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
              final moscowTime =
                  tz.TZDateTime.now(tz.getLocation('Europe/Moscow'));
              print('Current time in Moscow is $moscowTime');
              print('Current time in Moscow is ${widget.order.startTime}');

              App.changeIndex(1);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App()));
            },
          ),
          backgroundColor: const Color(0xFF2280BA),
          toolbarHeight: 40,
        ),
        backgroundColor: const Color(0xFFB6CFD8),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: widget.order.products.length,
                      (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: OrderProductCard(
                            product: widget.order.products[index],
                            order: widget.order));
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Общая стоимость ${widget.order.sum.truncate().toString()} руб/час",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: CountdownTimerWidget(
                  countdownDuration: widget.order.startTime.difference(
                          DateTime.now()) +
                      const Duration(minutes: 10))),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                setState(() {
                  getIt.get<OrderRepository>().cancel(widget.order.id);
                });
                App.changeIndex(1);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                );
              },
              child: const Text("Отменить",
                  style: TextStyle(
                    color: Colors.cyanAccent,
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
        fontFamily: 'PoiretOne',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
