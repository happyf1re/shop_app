import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: use_key_in_widget_constructors

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              icon: Icon(Icons.delete),
              color: Theme
                  .of(context)
                  .errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
