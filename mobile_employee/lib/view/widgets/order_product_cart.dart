import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../model/api/product_description_repository.dart';
import '../../model/domain/product.dart';
import '../../viewmodel/app_data.dart';
import '../../viewmodel/user_model.dart';

class OrderProductCard extends StatefulWidget {
  Product product;

  OrderProductCard({super.key, required this.product});

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFEFFBFD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.product.description.image,
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.product.description.title,
                style: const TextStyle(
                  fontFamily: 'PoiretOne',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                'Размер: ${widget.product.size}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'PoiretOne',
                  fontSize: 24,
                ),
              ),
              Text(
                'Стоимость: ${widget.product.description.price} руб/ч',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'PoiretOne',
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25))),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                              // child: _showSelectedSizes()
                              );
                            });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: const Text(
                      'Изменить размер',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PoiretOne',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {

                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: const Text(
                      'Убрать',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PoiretOne',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ))
        ],
      ),
    );
  }

  GetIt getIt = GetIt.instance;

  // StatefulWidget _showSelectedSizes() {
  //   return FutureBuilder(
  //     future: getIt<ProductDescriptionRepository>().getSizeByDate(
  //         getIt<AppData>().getDate()!, widget.product.description.id),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Container();
  //       } else {
  //         return Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: GridView.builder(
  //             itemCount: snapshot.data?.map.length,
  //             itemBuilder: (context, index) {
  //               double? key = snapshot.data?.map.keys.elementAt(index);
  //               return InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     Provider.of<UserModel>(context, listen: false)
  //                         .changeProduct(
  //                             widget.product.description.id,
  //                             widget.product.size,
  //                             snapshot.data?.map.keys.elementAt(index) ??
  //                                 widget.product.size);
  //                     Navigator.of(context).pop();
  //                     ScaffoldMessenger.of(context)
  //                         .showSnackBar(_changeSizeSnackBar());
  //                   });
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                       color: snapshot.data?.map[key] as bool
  //                           ? (snapshot.data?.map.keys.elementAt(index) ==
  //                                   widget.product.size
  //                               ? const Color(0xFF6831C0)
  //                               : const Color(0xFF5FE367))
  //                           : const Color(0xFFA89DB9),
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(10))),
  //                   child: Center(
  //                     child: Text(
  //                       '$key',
  //                       style: const TextStyle(
  //                           fontFamily: 'PoiretOne',
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 24),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 4,
  //               crossAxisSpacing: 10,
  //               mainAxisSpacing: 10,
  //             ),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

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
