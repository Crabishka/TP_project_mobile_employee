import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/domain/order.dart';
import '../../viewmodel/user_model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        color: const Color(0xFFEFFBFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  "Стоимость : ${order.sum} ",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF3C2C9E),
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text(
                    "Время :  ${order.date.day}-${order.date.month}-${order.date.year}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color(0xFF3C2C9E),
                      fontFamily: 'PoiretOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))),
            Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                child: Text("В статусе ${order.status.getStatusText()}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Color(0xFF3C2C9E),
                      fontFamily: 'PoiretOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ))),
            Container(
              height: (MediaQuery.of(context).size.width - 7 * 5) / 4,
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                              order.products[index].description.image),
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
