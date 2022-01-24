import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: use_key_in_widget_constructors

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //либо с провайдером, либо с консумером, как снизу
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //используем консумер только на этой кнопке
          //вверху мы передали провадеру listen: false
          //это означает, что теперь весь метод не будет ребилдится
          //изменяться будет только кнопка
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id as String, product.price, product.title);

              //просто штука, которая появляется при нажатии кнопки
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      //сделал отдельный метод, для уменьшения quantity
                      cart.removeSingleItem(product.id as String);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
