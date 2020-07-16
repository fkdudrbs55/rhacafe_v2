import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetail {
  final String ID;
  final String comment;
  final int score;
  final Timestamp timestamp;

  ItemDetail({this.ID, this.comment, this.score, this.timestamp});

  factory ItemDetail.fromFirestore(DocumentSnapshot doc){
    return ItemDetail(
        ID: doc.data['ID'] ?? '',
        comment: doc.data['comment'] ?? '',
        score: doc.data['score'] ?? '',
        timestamp: doc.data['timestamp'] ?? ''
    );
  }
}