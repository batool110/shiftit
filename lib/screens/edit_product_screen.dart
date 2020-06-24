// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _contactNumberFocusNode = FocusNode();
  final _vehicleNumberFocusNode = FocusNode();
  final _typeOfServiceFocusNode = FocusNode();
  final _cnicNumberFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    contactNumber: '',
    vehicleNumber: '',
    typeOfService: '',
    cnicNumber: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'contactNumber': '',
    'vehicleNumber': '',
    'typeOfService': '',
    'cnicNumber': '',
  };
  var _isInit = true;
  var _isLoading = false;

  List<String> _typeOfServices = [
    'Truck',
    'Shehzore',
    'Driver',
    'Loader',
  ]; // Option 2
  String _selectedTypeOfService;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'contactNumber': _editedProduct.contactNumber,
          'vehicleNumber': _editedProduct.vehicleNumber,
          'typeOfService': _editedProduct.typeOfService,
          'cnicNumber': _editedProduct.cnicNumber,
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
    _contactNumberFocusNode.dispose();
    _vehicleNumberFocusNode.dispose();
    _cnicNumberFocusNode.dispose();
    _typeOfServiceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

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

  File _storedImage;
  String _uploadedFileURL;

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('products/${Path.basename(_storedImage.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_storedImage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  Future<void> _takePictureFromGallery() async {
    var imageFileGallery = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
    );

    setState(() {
      _storedImage = imageFileGallery;
    });
  }

  // Future<void> _takePictureFromCamera() async {
  //   var imageFileCamera = await ImagePicker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 600,
  //     maxHeight: 600,
  //   );
  //   setState(() {
  //     _storedImage = imageFileCamera;
  //   });
  //   print('image of camera: '+ json.encode(_storedImage));
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      // print('Data of image' + _storedImage.path);
      // uploadFile();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            contactNumber: _editedProduct.contactNumber,
                            vehicleNumber: _editedProduct.vehicleNumber,
                            typeOfService: _editedProduct.typeOfService,
                            cnicNumber: _editedProduct.cnicNumber,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price per hour'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_contactNumberFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
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
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            contactNumber: _editedProduct.contactNumber,
                            vehicleNumber: _editedProduct.vehicleNumber,
                            typeOfService: _editedProduct.typeOfService,
                            cnicNumber: _editedProduct.cnicNumber,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['contactNumber'],
                      decoration: InputDecoration(labelText: 'Contact Number'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _contactNumberFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_typeOfServiceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a contact number.';
                        }
                        if (value.length < 11 || value.length > 11) {
                          return 'Should be 11 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            contactNumber: value,
                            vehicleNumber: _editedProduct.vehicleNumber,
                            typeOfService: _editedProduct.typeOfService,
                            cnicNumber: _editedProduct.cnicNumber,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: DropdownButton(
                        isDense: true,
                        focusNode: _typeOfServiceFocusNode,
                        hint: Text('Please choose your service'),
                        // value: _selectedTypeOfService,

                        items: _typeOfServices.map((typeOfService) {
                          return DropdownMenuItem(
                            child: new Text(typeOfService),
                            value: typeOfService,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                contactNumber: _editedProduct.contactNumber,
                                vehicleNumber: _editedProduct.vehicleNumber,
                                typeOfService: newValue,
                                cnicNumber: _editedProduct.cnicNumber,
                                isFavorite: _editedProduct.isFavorite,
                              );
                              this._selectedTypeOfService = newValue;
                            },
                          );
                        },
                        value: _selectedTypeOfService,
                      ),
                    ),
                    _selectedTypeOfService == 'Truck' ||
                            _selectedTypeOfService == 'Shehzore'
                        ? TextFormField(
                            initialValue: _initValues['vehicleNumber'],
                            decoration:
                                InputDecoration(labelText: 'Vehical Number'),
                            keyboardType: TextInputType.text,
                            focusNode: _vehicleNumberFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a vehicle Number.';
                              }
                              if (value.length < 5 || value.length > 5) {
                                return 'Should be 5 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                contactNumber: _editedProduct.contactNumber,
                                vehicleNumber: value,
                                typeOfService: _editedProduct.typeOfService,
                                cnicNumber: _editedProduct.cnicNumber,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          )
                        : Container(), 
                        TextFormField(
                            initialValue: _initValues['cnicNumber'],
                            decoration:
                                InputDecoration(labelText: 'CNIC Number'),
                            keyboardType: TextInputType.number,
                            focusNode: _cnicNumberFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a CNIC Number.';
                              }
                              if (value.length < 13 || value.length > 13) {
                                return 'Should be 13 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                contactNumber: _editedProduct.contactNumber,
                                vehicleNumber: _editedProduct.vehicleNumber,
                                typeOfService: _editedProduct.typeOfService,
                                cnicNumber: value,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                    // DropdownButton(
                    //   items: _typeOfServices.map((String dropDownStrindItem) {
                    //     return DropdownMenuItem(
                    //       value: dropDownStrindItem,
                    //       child: Text(dropDownStrindItem),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String newValueSelected) {
                    //     setState(() {
                    //       this._selectedTypeOfService = newValueSelected;
                    //     });
                    //   },
                    //   value: _selectedTypeOfService,
                    // ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          contactNumber: _editedProduct.contactNumber,
                          vehicleNumber: _editedProduct.vehicleNumber,
                          typeOfService: _editedProduct.typeOfService,
                          cnicNumber: _editedProduct.cnicNumber,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      // child: Center(
                      //   child: Column(
                      //     children: <Widget>[
                      //       Text('Selected Image'),
                      //       _image != null
                      //           ? Image.asset(
                      //               _image.path,
                      //               height: 150,
                      //             )
                      //           : Container(height: 150),
                      //       _image == null
                      //           ? RaisedButton(
                      //               child: Text('Choose File'),
                      //               onPressed: chooseFile,
                      //               color: Colors.cyan,
                      //             )
                      //           : Container(),
                      //       _image != null
                      //           ? RaisedButton(
                      //               child: Text('Upload File'),
                      //               onPressed: uploadFile,
                      //               color: Colors.cyan,
                      //             )
                      //           : Container(),
                      //       Text('Uploaded Image'),
                      //       _uploadedFileURL != null
                      //           ? Image.network(
                      //               _uploadedFileURL,
                      //               height: 150,
                      //             )
                      //           : Container(),
                      //     ],
                      //   ),
                      // ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
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
                            child: Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  color: Colors.orange,
                                  icon: Icon(
                                    Icons.photo,
                                    size: 20,
                                  ),
                                  label: Text('Add Picture from gallery.'),
                                  onPressed: () {
                                    _takePictureFromGallery();
                                  },
                                ),
                                // FlatButton.icon(
                                //   icon: Icon(Icons.photo_camera),
                                //   color: Colors.green,
                                //   label: Text('Take a picture.'),
                                //   onPressed: () {
                                //     _takePictureFromCamera();
                                //   },
                                // ),
                                FlatButton(
                                    child: new Text('Confirm image'),
                                    onPressed: () {
                                      uploadFile();
                                    }),
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  // keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _editedProduct.id != null
                                      ? _imageUrlController == null
                                          ? TextEditingController(
                                              text: 'select an image')
                                          : TextEditingController(
                                              text: _imageUrlController.text)
                                      : _uploadedFileURL == null
                                          ? TextEditingController(
                                              text: 'select an image')
                                          : TextEditingController(
                                              text: _uploadedFileURL),
                                  focusNode: _imageUrlFocusNode,
                                  onFieldSubmitted: (_) {
                                    _saveForm();
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter an image.';
                                    }
                                    if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return 'Please enter a valid URL.';
                                    }
                                    // if (!value.endsWith('.png') &&
                                    //     !value.endsWith('.jpg') &&
                                    //     !value.endsWith('.jpeg')) {
                                    //   return 'Please enter a valid image URL.';
                                    // }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedProduct = Product(
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      description: _editedProduct.description,
                                      imageUrl: value,
                                      id: _editedProduct.id,
                                      contactNumber:
                                          _editedProduct.contactNumber,
                                      vehicleNumber:
                                          _editedProduct.vehicleNumber,
                                      typeOfService:
                                          _editedProduct.typeOfService,
                                      cnicNumber: _editedProduct.cnicNumber,
                                      isFavorite: _editedProduct.isFavorite,
                                    );
                                  },
                                )
                              ],
                            ),
                            // child: TextFormField(
                            //   decoration: InputDecoration(labelText: 'Image URL'),
                            //   keyboardType: TextInputType.url,
                            //   textInputAction: TextInputAction.done,
                            //   controller: _imageUrlController,
                            //   focusNode: _imageUrlFocusNode,
                            //   onFieldSubmitted: (_) {
                            //     _saveForm();
                            //   },
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter an image URL.';
                            //     }
                            //     if (!value.startsWith('http') &&
                            //         !value.startsWith('https')) {
                            //       return 'Please enter a valid URL.';
                            //     }
                            //     if (!value.endsWith('.png') &&
                            //         !value.endsWith('.jpg') &&
                            //         !value.endsWith('.jpeg')) {
                            //       return 'Please enter a valid image URL.';
                            //     }
                            //     return null;
                            //   },
                            //   onSaved: (value) {
                            //     _editedProduct = Product(
                            //       title: _editedProduct.title,
                            //       price: _editedProduct.price,
                            //       description: _editedProduct.description,
                            //       imageUrl: value,
                            //       id: _editedProduct.id,
                            //       contactNumber: _editedProduct.contactNumber,
                            //       vehicleNumber: _editedProduct.vehicleNumber,
                            //       typeOfService: _editedProduct.typeOfService,
                            //       cnicNumber: _editedProduct.cnicNumber,
                            //       isFavorite: _editedProduct.isFavorite,
                            //     );
                            //   },
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
