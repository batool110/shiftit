import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/request_grid.dart';
import '../widgets/badge.dart';
import '../providers/requests.dart';

enum FilterOptions {
  Favorites,
  All,
}

class RequestsOverviewScreen extends StatefulWidget {
  static const routeName = '/request-overview';

  @override
  _RequestsOverviewScreenState createState() => _RequestsOverviewScreenState();
}

class _RequestsOverviewScreenState extends State<RequestsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Requests>(context).fetchAndSetRequests().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // int _current = 0;
  // List imgList = [
  //   'https://thumbs.dreamstime.com/z/beautiful-pakistani-truck-standing-rural-area-you-can-also-see-brick-kiln-background-beautiful-pakistani-truck-117026164.jpg',
  //   'https://cache4.pakwheels.com/system/car_generation_pictures/4778/original/Daehan_Shehzore.jpg?1523015517',
  //   'https://upload.wikimedia.org/wikipedia/commons/2/21/Suzuki_Carry_Truck_KC_4WD_DA16T.JPG',
  //   'https://cargeek.pk/wp-content/uploads/2017/05/Hyundai-Shehzore-H100.jpg'
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
