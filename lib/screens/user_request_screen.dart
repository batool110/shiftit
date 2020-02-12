import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/requests.dart';
import '../widgets/user_request_item.dart';
import '../widgets/app_drawer.dart';
import './edit_request_screen.dart';

class UserRequestsScreen extends StatelessWidget {
  static const routeName = '/user-request';

  Future<void> _refreshReqursts(BuildContext context) async {
    await Provider.of<Requests>(context, listen: false)
        .fetchAndSetRequests(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Request'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditRequestScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshReqursts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshReqursts(context),
                    child: Consumer<Requests>(
                      builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) => Column(
                                    children: [
                                      UserRequestItem(
                                        productsData.items[i].id,
                                        productsData.items[i].name,
                                        productsData.items[i].contactNumber,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            ),
                          ),
                    ),
                  ),
      ),
    );
  }
}
