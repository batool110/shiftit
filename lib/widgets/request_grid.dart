import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/requests.dart';
import './request_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final requestsData = Provider.of<Requests>(context);
    final requests = showFavs ? requestsData.favoriteItems : requestsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: requests.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            // builder: (c) => products[i],
            value: requests[i],
            child: ProductItem(
                // products[i].id,
                // products[i].title,
                // products[i].imageUrl,
                ),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
