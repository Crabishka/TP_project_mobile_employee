import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/api/order_repository.dart';
import 'package:mobile_employee/model/domain/order.dart';

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
                  countdownDuration:
                      widget.order.startTime.difference(DateTime.now()) +
                          const Duration(minutes: 10))),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                setState(() {
                  getIt.get<OrderRepository>().finish(widget.order.id);
                });
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OrderInfo(code: widget.order.id.toString())),
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

class ButtonState with ChangeNotifier {
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  void disableButton() {
    _isEnabled = false;
    notifyListeners();
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
    timer = Timer.periodic(Duration(seconds: 1), (_) {
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
