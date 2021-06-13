import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Great Places'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child: Center(
                    child: Text('No place Added yet!'),
                  ),
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.getItems.length <= 0
                          ? ch as Widget
                          : ListView.builder(
                              itemCount: greatPlaces.getItems.length,
                              itemBuilder: (ctx, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                      greatPlaces.getItems[index].image),
                                ),
                                title: Text(greatPlaces.getItems[index].title),
                                subtitle: Text(greatPlaces
                                    .getItems[index].loaction!.address
                                    .toString()),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(PlaceDetailScreen.routeName,arguments: greatPlaces.getItems[index].id);
                                },
                              ),
                            ),
                ),
        ));
  }
}
