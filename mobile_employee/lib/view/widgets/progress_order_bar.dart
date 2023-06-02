import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/domain/order.dart';

class ProgressOrderBar extends StatelessWidget {
  final Order order;

  const ProgressOrderBar({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return _buildStatus(order);
  }

  Row _buildStatus(Order order) {
    double circleGap = 15;
    Color cartingColor = (order.status.index >= OrderStatus.CARTING.index)
        ? const Color(0xFFb43e69)
        : const Color(0xFF3EB489);
    Color waitingColor =
        (order.status.index >= OrderStatus.WAITING_FOR_RECEIVING.index)
            ? const Color(0xFFb43e69)
            : const Color(0xFF3EB489);
    Color fittingColor = (order.status.index >= OrderStatus.FITTING.index)
        ? const Color(0xFFb43e69)
        : const Color(0xFF3EB489);
    Color activeColor = (order.status.index >= OrderStatus.ACTIVE.index)
        ? const Color(0xFFb43e69)
        : const Color(0xFF3EB489);
    Color paymentColor =
        (order.status.index >= OrderStatus.WAITING_FOR_PAYMENT.index)
            ? const Color(0xFFb43e69)
            : const Color(0xFF3EB489);
    Color finishColor = (order.status.index >= OrderStatus.FINISHED.index)
        ? const Color(0xFFb43e69)
        : const Color(0xFF3EB489);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circle(cartingColor,
            const Icon(Icons.shopping_basket_outlined, color: Colors.white)),
        Container(
          width: circleGap,
          height: 10,
          color: waitingColor,
        ),
        circle(
            waitingColor, const Icon(Icons.access_time, color: Colors.white)),
        Container(
          width: circleGap,
          height: 10,
          color: fittingColor,
        ),
        circle(fittingColor,
            const Icon(Icons.accessibility_new_outlined, color: Colors.white)),
        Container(
          width: circleGap,
          height: 10,
          color: activeColor,
        ),
        circle(
            activeColor, const Icon(Icons.directions_run, color: Colors.white)),
        Container(
          width: circleGap,
          height: 10,
          color: paymentColor,
        ),
        circle(paymentColor,
            const Icon(Icons.monetization_on_outlined, color: Colors.white)),
        Container(
          width: circleGap,
          height: 10,
          color: finishColor,
        ),
        circle(finishColor, const Icon(Icons.check, color: Colors.white))
      ],
    );
  }

  Widget circle(Color color, Icon icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: icon,
    );
  }
}
