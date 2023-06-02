import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_employee/model/domain/order.dart';
import 'package:provider/provider.dart';

import '../../model/domain/order_DTO.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderDTO order;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        color: const Color(0xFFEFFBFD),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                  "Номер телефона: ${order.phoneNumber}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                  "Имя: ${order.name}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                    "Дата: ${DateFormat('dd-MMM').format(order.order.date)}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'PoiretOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ))),
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(order.order.status.getStatusText(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontFamily: 'PoiretOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ))),
            Container(
              height: (MediaQuery.of(context).size.width - 7 * 6) / 4,
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.order.products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                              order.order.products[index].description.image),
                        ));
                  }),
            ),
            const SizedBox(
              height: 8,
            )
          ]),
        ));
  }
}
