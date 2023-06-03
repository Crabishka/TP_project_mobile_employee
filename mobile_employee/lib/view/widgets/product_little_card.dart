import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/domain/product.dart';

class ProductLittleCard extends StatelessWidget {
  Product product;

  ProductLittleCard({super.key, required this.product});

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
                  width: 116,
                  height: 100,
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      product.description.image,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Text(
                          product.description.title,
                          maxLines: 2,
                          style: const TextStyle(

                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Размер: ${product.size}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(

                          fontSize: 16,
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
            color: Color(0x10000000),
            thickness: 1,
          )
        ],
      ),
    );
  }
}
