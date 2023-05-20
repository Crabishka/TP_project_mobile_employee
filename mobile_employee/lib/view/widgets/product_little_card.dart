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
      elevation: 4,
      color: const Color(0xFFEFFBFD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: product.description.image,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.description.title,
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Размер: ${product.size}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Цена: ${product.description.price} руб/час',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'PoiretOne',
                    fontSize: 16,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
