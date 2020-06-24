import 'package:bmi_calculator/providers/scheduleItem.dart';
import 'package:bmi_calculator/screens/user_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/requests.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './providers/emloyees.dart';
import './providers/employee.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/addEmployScreen.dart';
// import './screens/products_overview_screen.dart';
import './screens/edit_request_screen.dart';
import './screens/request_overview_screen.dart';
// import './screens/request_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        ChangeNotifierProxyProvider<Auth, Requests>(
          builder: (ctx, auth, previousRequests) => Requests(
                auth.token,
                auth.userId,
                previousRequests == null ? [] : previousRequests.items,
              ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: ScheduleItem(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
                auth.token,
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders,
              ),
        ),
        ChangeNotifierProvider.value(
          value: Employees(),
        ),
        ChangeNotifierProvider.value(
          value: Employee(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'ShiftIt',
              theme: ThemeData(
                primarySwatch: Colors.teal,
                accentColor: Colors.pink,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                EditRequestScreen.routeName: (ctx) => EditRequestScreen(),
                UserRequestsScreen.routeName: (ctx) => UserRequestsScreen(),
                RequestsOverviewScreen.routeName: (ctx) => RequestsOverviewScreen(),
                AddEmployeeScreen.routeName: (ctx) =>AddEmployeeScreen(),
              },
            ),
      ),
    );
  }
}
