import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/Comment.dart';
import 'package:rhacafe_v1/views/AddCommentView.dart';
import 'package:rhacafe_v1/views/widgets/CommentSection.dart';
import '../services/DatabaseService.dart';

//TODO 사진 슬라이드 충분? UI 및 기능 고민

class DetailView extends StatelessWidget {
  final CafeItem item;

  DetailView(this.item);

  Widget imageSlider(List<String> imageUrls, BuildContext context) {


    if (imageUrls.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            color: Colors.white
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              height: MediaQuery.of(context).size.height / 3,
            ),
            items: imageUrls
                .map(
                  (e) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      imageUrl: e,
//                  fit: BoxFit.cover,
                    )),
              ),
            )
                .toList(),
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: imageUrls.map((url) {
//              int index = imageUrls.indexOf(url);
//              return Container(
//                width: 8.0,
//                height: 8.0,
//                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                decoration: BoxDecoration(
//                  shape: BoxShape.circle,
//                  color: _current == index
//                      ? Color.fromRGBO(0, 0, 0, 0.9)
//                      : Color.fromRGBO(0, 0, 0, 0.4),
//                ),
//              );
//            }).toList(),
//          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    GoogleMapController mapController;

    FirebaseUser user = Provider.of(context);

    LatLng _center;

    if(item.geopoint[0] == null){
      _center = LatLng(item.geopoint.values.toList()[0], item.geopoint.values.toList()[1]);
    } else{
      _center = LatLng(item.geopoint[0], item.geopoint[1]);

    }

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddCommentView(user, item)));
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
                    imageSlider(item.imageUrl, context),
//                    Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: MediaQuery.of(context).size.height/3,
//                      child: FittedBox(
//                          fit: BoxFit.cover,
//                          child: CachedNetworkImage(
//                            placeholder: (context, url) =>
//                                Container(
//                                  width: MediaQuery.of(context).size.width,
//                                  height: MediaQuery.of(context).size.height/3,
//                                  child: Center(
//                                      child: CircularProgressIndicator()
//                                  ),
//                                ),
//                            imageUrl: item.imageUrl[0],
//                          )),
//                    ),
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
                                  flex: 8,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
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
                                  flex: 2,
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
                                  flex: 2,
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

            CommentSection(item),
          ],
        ),
      ),
    );
  }
}
