import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/request.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           content: ListTile(
  //             title: Text(message['notification']['title']),
  //             subtitle: Text(message['notification']['body']),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Ok'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       // TODO optional
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       // TODO optional
  //     },
  //   );
  // }

  //  _saveDeviceToken() async {
  //   // Get the current user
  //   // String uid = 'jeffd23';
  //   FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;

  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();

  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     var tokens = _db
  //         .collection('users')
  //         .document(uid)
  //         .collection('tokens')
  //         .document(fcmToken);

  //     await tokens.setData({
  //       'token': fcmToken,
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       // 'platform': Platform.operatingSystem // optional
  //     });
  //   }
  // }

  Future<FirebaseUser> _getData() async {
    FirebaseUser user = await _auth.currentUser();
    print(user);

    return _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<Request>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Name: ' + request.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text('Frome Where: ' + request.fromWhere),
                Text('To Where: ' + request.toWhere),
                Text('Contact Number: ' + request.contactNumber),
                Text('Shifting Date: ' + request.date.toString()),
                Text('Time: ' + request.expectedTime.toString()),
                Text('Capacity: ' + request.capasity),
                Text('description: ' + request.description),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Price: ' + request.price.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // FlatButton(
                //     child: Text('Show Interest'), onPressed: () => _getData()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ProductItem extends StatelessWidget {
//   // final String id;
//   // final String title;
//   // final String imageUrl;

//   // ProductItem(this.id, this.title, this.imageUrl);

//   @override
//   Widget build(BuildContext context) {
//     final product = Provider.of<Product>(context, listen: false);
//     final cart = Provider.of<Cart>(context, listen: false);
//     final authData = Provider.of<Auth>(context, listen: false);
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Card(
//         // child: GestureDetector(
//           // onTap: () {
//           //   Navigator.of(context).pushNamed(
//           //     ProductDetailScreen.routeName,
//           //     arguments: product.id,
//           //   );
//           // },
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   Text('Name: ' + product.name),
//                   Text('Frome Where: ' + product.fromWhere),
//                   Text('To Where: ' + product.toWhere),
//                   Text('Contact Number: ' + product.contactNumber),
//                   Text('Shifting Date: ' + product.date.toString()),
//                   Text('Time: ' + product.expectedTime.toString()),
//                   Text('description: ' + product.description),
//                 ],
//               ),
//             ),
//           ),
//           // child: Image.network(
//           //   product.imageUrl,
//           //   fit: BoxFit.cover,
//           // ),
//         // ),
//         // footer: GridTileBar(
//         //   backgroundColor: Colors.black87,
//         //   leading: Consumer<Product>(
//         //     builder: (ctx, product, _) => IconButton(
//         //       icon: Icon(
//         //         product.isFavorite ? Icons.favorite : Icons.favorite_border,
//         //       ),
//         //       color: Theme.of(context).accentColor,
//         //       onPressed: () {
//         //         product.toggleFavoriteStatus(
//         //           authData.token,
//         //           authData.userId,
//         //         );
//         //       },
//         //     ),
//         //   ),
//         //   title: Text(
//         //     'Rs: ' +
//         //         product.price.toString() +
//         //         ' \n capacity: ' +
//         //         product.capasity + ' tons',
//         //     textAlign: TextAlign.center,
//         //   ),
//         //   trailing: IconButton(
//         //     icon: Icon(
//         //       Icons.shopping_cart,
//         //     ),
//         //     onPressed: () {
//         //       cart.addItem(product.id, product.price, product.name);
//         //       Scaffold.of(context).hideCurrentSnackBar();
//         //       Scaffold.of(context).showSnackBar(
//         //         SnackBar(
//         //           content: Text(
//         //             'Added item to cart!',
//         //           ),
//         //           duration: Duration(seconds: 5),
//         //           action: SnackBarAction(
//         //             label: 'UNDO',
//         //             onPressed: () {
//         //               cart.removeSingleItem(product.id);
//         //             },
//         //           ),
//         //         ),
//         //       );
//         //     },
//         //     color: Theme.of(context).accentColor,
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
