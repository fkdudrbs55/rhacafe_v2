import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/ItemDetail.dart';

import '../services/DatabaseService.dart';

//TODO 2 Incorrect use of ParentDataWidget. Fix

class DetailView extends StatelessWidget {
  final CafeItem item;

  DetailView(this.item);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final DatabaseService _db = DatabaseService();

    GoogleMapController mapController;

    final LatLng _center = LatLng(item.geopoint[0], item.geopoint[1]);

    //TODO Separate map related factors into MapService?
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return FutureBuilder<List<DocumentSnapshot>>(
        future: _db.getItemDetailSnapshotList(item),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new CircularProgressIndicator();

          DocumentSnapshot doc = snapshot.data.elementAt(0);

          ItemDetail itemDetail = _db.deriveItemDetail(doc);

          print(item.geopoint);

          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FittedBox(
                              fit: BoxFit.contain,
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: item.imageUrl,
                                fit: BoxFit.fitHeight,
                              )),
                          SizedBox(
                            width: double.infinity,
                            height: 240,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Positioned(
                          width: double.infinity,
                          top: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //TODO Add star bar after having scoring mechanism
                              Text(item.name, style: textTheme.headline1),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.star_border),
                                  Icon(Icons.comment),
                                  Icon(Icons.place)
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 120,
                                width: double.infinity,
                                child: Text('뭘 넣을까', style: textTheme.bodyText1,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        )),
                  )
                  //TODO 1 Add comment section
                ],
              ),
            ),
          );
        });
  }
}
