import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: use_key_in_widget_constructors

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  //
  //
  // ProductDetailScreen(this.title, this.price);
  static const routName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    //используем провайдер... сначала используем аргумент, который передали в product_item,
    //это был id... items у products получает копию списка _items
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      //аргумент listen false вызывается для того, чтобы при изменении продукта,
      //который мы получили, весь метод build не перезапускался
      //т.е. при изменении Products, например, при добавлении нового, перезапустятся
      //все методы build, где есть Provider, который слушает этот класс и
      //listen: true (что есть дефолт)
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
