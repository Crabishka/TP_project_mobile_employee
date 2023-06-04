import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../model/api/order_repository.dart';
import '../../model/api/product_description_repository.dart';
import '../../model/domain/order.dart';
import '../../model/domain/product.dart';
import '../../model/domain/product_size_dto.dart';
import '../../viewmodel/app_data.dart';
import '../../viewmodel/user_model.dart';
import '../qr/order/order_info.dart';

class OrderProductCard extends StatefulWidget {
  Product product;
  Order order;

  OrderProductCard({super.key, required this.product, required this.order});

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  GetIt getIt = GetIt.instance;
  int _selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFFBFD),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 146,
                  height: 130,
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: ClipRRect(
                    child: Image.network(
                      widget.product.description.image,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            widget.product.description.title,
                            maxLines: 2,
                            style: const TextStyle(

                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            alignment: Alignment.topCenter,
                              onPressed: () {
                                setState(() {
                                  getIt
                                      .get<OrderRepository>()
                                      .removeProduct(
                                          widget.order.id,
                                          widget.product.description.id,
                                          widget.product.size)
                                      .then((value) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) => OrderInfo(
                                              code: widget.order.id.toString())),
                                    );
                                  });
                                });
                              },
                              icon: const Icon(Icons.cancel_outlined, size: 24,)),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '${widget.product.description.price.truncate().toString()} руб/ч',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(

                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Размер: ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(

                          fontSize: 16,
                        ),
                      ),
                      // if (getIt.get<AppData>().isChange)
                      CupertinoButton(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _showDialog();
                        },
                        child: Row(
                          children: [
                            Text(
                              widget.product.size.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,

                                fontSize: 16,
                              ),
                            ),
                            const Icon(Icons.expand_more, color: Colors.black, size: 16,),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  )
                ],
              )),
            ],
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  void _showDialog() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return FutureBuilder<ProductSizeDTO>(
            future: getIt<ProductDescriptionRepository>().getSizeByDate(
                widget.order.date, widget.product.description.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return Container(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  height: 216,
                  child: Column(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32,
                          scrollController: FixedExtentScrollController(
                            initialItem: snapshot.data?.map.keys
                                    .toList()
                                    .indexOf(widget.product.size) ??
                                0,
                          ),
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              _selectedSize = selectedItem;
                            });
                          },
                          children: getSizeWidget(snapshot.data!),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(200, 40),
                              backgroundColor: const Color(0xFF3EB489),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            setState(() {
                              getIt
                                  .get<OrderRepository>()
                                  .changeSize(
                                      widget.order.id,
                                      widget.product.description.id,
                                      widget.product.size,
                                      snapshot.data?.map.keys
                                              .elementAt(_selectedSize) ??
                                          widget.product.size)
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_changeSizeSnackBar());
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => OrderInfo(
                                          code: widget.order.id.toString())),
                                );
                              });
                            });
                          },
                          child: const Text("Изменить размер",
                              style: TextStyle(

                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ))),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                );
              }
            },
          );
        });
  }

  List<Widget> getSizeWidget(ProductSizeDTO dto) {
    Map<double, bool> map = dto.map;
    map.removeWhere((key, value) => value == false);
    return map.entries.map((entry) {
      double size = entry.key;
      bool selected = entry.value;
      return Text(
        size.toString(),
        style: TextStyle(
          fontSize: selected ? 24.0 : 16.0,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      );
    }).toList();
  }

  SnackBar _changeSizeSnackBar() {
    return SnackBar(
      content: const Text('Вы изменили размер!'),
      action: SnackBarAction(
        label: 'Хорошо',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }
}
