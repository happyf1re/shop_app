import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: use_key_in_widget_constructors
//ignore_for_file: prefer_final_fields

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //эта штука позволяет нам переходить в следующему полю ввода, по нажатию
  //на клавишу
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  //formState из material.dart... эта штука нужна, чтобы при редактировании/добавлении
  //товара, форма сохранилась. Используем глобальный ключ
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    title: '',
    id: null,
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  //метод ниже не обязателен, всё будет работать и без него
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  //используем этот метод, т.к. не можем воспользоваться ModalRoute в initState
  @override
  void didChangeDependencies() {
    if (_isInit) {
      //принимаем именно id, мы это сами задаём в userproductitem на 29 строке
      final productId = ModalRoute.of(context)!.settings.arguments;
      //просто так проверка.. она не нужна, можно убрать, null safety, все дела
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //c фокус нодами нужно так поступать, дабы избежать утечек памяти
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  //метод ниже не обязателен, всё будет работать и без него
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id as String, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                //валидатор. если возвращается null, значит всё верно,
                //если строка, то не прошли валидацию
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value as String,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  //tryParse проверяет дабл ли это
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value!),
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                //описание - длинное, maxLines для этого
                maxLines: 3,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value as String,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          imageUrl: value as String,
                        );
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
