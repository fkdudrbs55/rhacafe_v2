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

class DetailView extends StatelessWidget {
  final CafeItem item;

  DetailView(this.item);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    GoogleMapController mapController;

    final LatLng _center = LatLng(item.geopoint[0], item.geopoint[1]);

    //TODO Separate map related factors into MapService?
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
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () {
//          _db.addDemoDocument(item.documentID, {
//            'ID': user.uid,
//            'comment': '좋았어요',
//            'score': 4,
//            'timestamp': Timestamp.now(),
//            'photoUrl': user.photoUrl
//          });
//        },
//      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3,
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/3,
                                  child: Center(
                                      child: CircularProgressIndicator()
                                  ),
                                ),
                            imageUrl: item.imageUrl,
                          )),
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height/3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 7,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),

                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.local_cafe),
                                      SizedBox(width: 10),
                                      Text(
                                        item.name,
                                        style: textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
//                            SizedBox(height: 15),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.place),
                                      SizedBox(width: 10),
                                      Text(
                                        item.location,
                                        style: textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.phone),
                                      SizedBox(width: 10),
                                      Text(
                                        item.contact,
                                        style: textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ),
                            Expanded(
                              flex: 1,
                                child: SizedBox(height: 5)),
                              ],
                            ),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  top: MediaQuery.of(context).size.height/4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.name, style: textTheme.headline1),
                      Row(
                        //TODO Score calculating functionality > Separate to ViewModel
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
                          child: Center(
                            child: Text(
                              item.content,
                              style: textTheme.bodyText1,
                            ),
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
