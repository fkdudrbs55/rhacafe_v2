import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/Comment.dart';
import 'package:rhacafe_v1/views/widgets/CommentSection.dart';

import '../services/DatabaseService.dart';

//TODO Should I use Flexible to ensure that widgets are adjustable?

class DetailView extends StatelessWidget {
  final CafeItem item;

  DetailView(this.item);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    GoogleMapController mapController;

    FirebaseUser user = Provider.of(context);
    DatabaseService _db = DatabaseService();

    final LatLng _center = LatLng(item.geopoint[0], item.geopoint[1]);

    //TODO Separate map related factors into MapService? How should I restrict this?
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    Set<Marker> markers = Set();
    markers.addAll([
      Marker(
        markerId: MarkerId('default'),
        position: _center,
      )
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _db.addDemoDocument(item.documentID, {
            'ID': user.uid,
            'comment': 'w좋았어요',
            'score': 4,
            'timestamp': Timestamp.now(),
            'photoUrl': user.photoUrl
          });
        },
      ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.local_cafe),
                                SizedBox(width: 10),
                                Text(
                                  item.name,
                                  style: textTheme.bodyText1,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.place),
                                SizedBox(width: 10),
                                Text(
                                  item.location,
                                  style: textTheme.bodyText1,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone),
                                SizedBox(width: 10),
                                Text(
                                  item.contact,
                                  style: textTheme.bodyText1,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  top: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.name, style: textTheme.headline1),
                      Row(
                        //TODO 1 Add content # + score calculating functionality > Separate to ViewModel
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.star_border, color: Colors.white),
                              Text('평점', style: textTheme.headline4,)
                            ],
                          ),

                          SizedBox(width: 30),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.comment, color: Colors.white),
                              Text('리뷰', style: textTheme.headline4)
                            ],
                          ),

                          SizedBox(width: 30),

                          Icon(Icons.place, color: Colors.white),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          //TODO How to fill this text space? Currently just copying main view
                          child: Text(
                            item.content,
                            style: textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 240,
              child: GoogleMap(
                  markers: markers,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.5,
                  )),
            ),

            //Future Builder 를 아예 CommentTile로 보내버리자
            CommentSection(item),
          ],
        ),
      ),
    );
  }
}
