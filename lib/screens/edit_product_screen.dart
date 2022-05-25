import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Products(id: '', title: '', price: 0, description: '', imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        _editedProduct = Provider.of<Product>(context, listen: false)
            .findById(productId as String);
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

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    //print(_editedProduct.id);
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      await Provider.of<Product>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Product>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        // await Provider.of<Product>(context, listen: false)
        //     .addProducts(_editedProduct)
        //     .catchError((error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error Occured!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }
      // }).then((_) {
      //  finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    // Navigator.of(context).pop();

    // print(_editedProduct.imageUrl);
    // print(_editedProduct.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Products(
                              title: value!,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide a value.';
                            }
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a number greater than zero.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Products(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              price: double.parse(value!),
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter description details.';
                            }
                            if (value.length < 10) {
                              return 'Should be atleast 10 characters long.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Products(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: value!,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                            );
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    )),
                            ),
                            Expanded(
                              child: TextFormField(
                                //initialValue: _initValues['imageUrl'],
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an image url.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'please enter a valid url';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpeg') &&
                                      !value.endsWith('.jpg')) {
                                    return 'please enter a valid  image url';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Products(
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value!,
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
