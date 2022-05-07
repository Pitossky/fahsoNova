import 'package:flutter/material.dart';
import 'package:pappi_store/model/product_model.dart';
import 'package:pappi_store/model/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/manage-products';

  const ManageProductScreen({Key? key}) : super(key: key);

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgFocusNode = FocusNode();
  final _imgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editableProducts = ProductModel(
    prodId: null,
    prodTitle: '',
    prodDesc: '',
    prodPrice: 0,
    prodImage: '',
  );

  var _initialProdValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _loadData = false;

  @override
  void initState() {
    _imgFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final editedProdId =
          ModalRoute.of(context)!.settings.arguments as String?;
      if (editedProdId != null) {
        _editableProducts = Provider.of<ProductProvider>(context, listen: false)
            .findById(editedProdId);
        _initialProdValues = {
          'title': _editableProducts.prodTitle,
          'description': _editableProducts.prodDesc,
          'price': _editableProducts.prodPrice.toString(),
          'imageUrl': '',
        };
        _imgController.text = _editableProducts.prodImage;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgFocusNode.removeListener(_updateImgUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgFocusNode.dispose();
    _imgController.dispose();
    super.dispose();
  }

  void _updateImgUrl() {
    if (!_imgFocusNode.hasFocus) {
      if (_imgController.text.isEmpty ||
          (_imgController.text.startsWith('http') &&
              _imgController.text.startsWith('https')) ||
          (_imgController.text.endsWith('.png') &&
              _imgController.text.endsWith('.jpg') &&
              _imgController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveProductInputs() async {
    final formValidator = _formKey.currentState!.validate();
    if (!formValidator) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _loadData = true;
    });
    if (_editableProducts.prodId != null) {
      await Provider.of<ProductProvider>(context, listen: false).updateProduct(
        _editableProducts.prodId.toString(),
        _editableProducts,
      );
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProductItem(_editableProducts);
        Navigator.of(context).pop();
      } catch (errData) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OKAY'),
              ),
            ],
          ),
        );
      }
      /*
      finally {
        setState(() {
          _loadData = false;
        });
        Navigator.of(context).pop();
      }
      */
    }
    setState(() {
      _loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: _saveProductInputs,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _loadData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initialProdValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Input Product Title',
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please input a Product Title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editableProducts = ProductModel(
                            prodId: _editableProducts.prodId,
                            prodTitle: value.toString(),
                            prodDesc: _editableProducts.prodDesc,
                            prodPrice: _editableProducts.prodPrice,
                            prodImage: _editableProducts.prodImage,
                            isFav: _editableProducts.isFav,
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: _initialProdValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Input Product Price',
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please input a Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid Price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editableProducts = ProductModel(
                            prodId: _editableProducts.prodId,
                            prodTitle: _editableProducts.prodTitle,
                            prodDesc: _editableProducts.prodDesc,
                            prodPrice: double.parse(value!),
                            prodImage: _editableProducts.prodImage,
                            isFav: _editableProducts.isFav,
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: _initialProdValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Input Product Description',
                          floatingLabelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        maxLines: 3,
                        //textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a Description';
                          }
                          if (value.length < 10) {
                            return 'Should be at least ten characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editableProducts = ProductModel(
                            prodId: _editableProducts.prodId,
                            prodTitle: _editableProducts.prodTitle,
                            prodDesc: value.toString(),
                            prodPrice: _editableProducts.prodPrice,
                            prodImage: _editableProducts.prodImage,
                            isFav: _editableProducts.isFav,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 15, right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imgController.text.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Enter Image URL',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 17,
                                      ),
                                    ),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imgController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: _initialProdValues['imageUrl'],
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                                floatingLabelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imgController,
                              focusNode: _imgFocusNode,
                              onFieldSubmitted: (_) => _saveProductInputs(),
                              onEditingComplete: () {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an image URL';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editableProducts = ProductModel(
                                  prodId: _editableProducts.prodId,
                                  prodTitle: _editableProducts.prodTitle,
                                  prodDesc: _editableProducts.prodDesc,
                                  prodPrice: _editableProducts.prodPrice,
                                  prodImage: value.toString(),
                                  isFav: _editableProducts.isFav,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
