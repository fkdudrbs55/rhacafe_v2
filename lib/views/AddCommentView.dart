import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/Comment.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AddCommentView extends StatefulWidget {
  FirebaseUser user;
  CafeItem item;

  AddCommentView(this.user, this.item);

  @override
  State<StatefulWidget> createState() {
    return _AddCommentViewState();
  }
}

class _AddCommentViewState extends State<AddCommentView> {
  final myTextController = TextEditingController();
  final DatabaseService _db = DatabaseService();
  double _score = 3;

  void submitComment() {
    Comment comment = Comment(
        uid: widget.user.uid,
        username: widget.user.displayName,
        comment: myTextController.text,
        score: _score,
        timestamp: Timestamp.now().toDate(),
        photoUrl: widget.user.photoUrl);

    _db.addComment(widget.item, comment);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 7,
        ),
        Center(
            child: SmoothStarRating(
          isReadOnly: false,
          size: 50,
          color: Colors.deepOrange,
          borderColor: Colors.deepOrange,
          filledIconData: Icons.star,
          halfFilledIconData: Icons.star_half,
          defaultIconData: Icons.star_border,
          starCount: 5,
          allowHalfRating: true,
          spacing: 2.0,
          rating: _score,
          onRated: (value) {
            _score = value;
            // print("rating value dd -> ${value.truncate()}");
          },
        )),
        SizedBox(
          height: MediaQuery.of(context).size.height / 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            decoration:
                BoxDecoration(color: Colors.white, border: Border.all()),
            child: TextFormField(
              style: textTheme.bodyText1,
              maxLines: 20,
              maxLength: 500,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "드래그해서 별점을 매겨주시고, 식사가 어땠는지 공유해주세요!",
              ),
              controller: myTextController,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            RaisedButton(
                onPressed:() => Navigator.of(context).pop(),
                child: Text('취소', style: textTheme.bodyText1,)
            ),

            SizedBox(width: 15,),

            RaisedButton(
              onPressed: submitComment,
              child: Text('제출하기', style: textTheme.bodyText1,),
            ),


          ],
        )
      ],
    ));
  }
}
