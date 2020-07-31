import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/Comment.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:rhacafe_v1/views/widgets/SmoothStarRating.dart';

class CommentSection extends StatelessWidget {
  //TODO 1 UI 다듬자

  final CafeItem item;

  CommentSection(this.item);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final DatabaseService _db = DatabaseService();

    return FutureBuilder<List<DocumentSnapshot>>(
        future: _db.getCommentSnapshotList(item),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text('아직 리뷰가 없습니다');
          }

          List<Comment> commentList = _db.deriveCommentList(snapshot.data);

          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text('리뷰', style: textTheme.bodyText1)),
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                ),
                Column(
                    children: commentList
                        .map((e) => ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 60),
                              child: Row(
                                children: <Widget>[
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      width: 40,
                                      height: 40,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      imageUrl: e.photoUrl,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                e.ID,
                                                style: textTheme.bodyText1,
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 8)),
                                          Text(
                                            e.comment,
                                            style: textTheme.bodyText1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SmoothStarRating(
                                      allowHalfRating: true,
//                              onRated: (v) {
//                              },
                                      starCount: 5,
                                      rating: e.score,
                                      size: 15.0,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      color: Colors.yellow,
                                      borderColor: Colors.yellow,
                                      spacing: 0.0),
                                  SizedBox(width: 10),
                                  Text(
                                    DateFormat('yyyy-MM-dd')
                                        .format(e.timestamp),
                                    style: textTheme.bodyText2,
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ))
                        .toList()),
              ],
            ),
          );
        });
  }
}
