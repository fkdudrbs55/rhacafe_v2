import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'dart:async';
import '../models/Comment.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<CafeItem>> streamCafeList() {
    return _db.collection('SampleCollection').snapshots().map(
        (list) => list.documents.map((doc) => deriveCafeItem(doc)).toList());
  }

  CafeItem deriveCafeItem(DocumentSnapshot doc) {
    GeoPoint geoPoint = doc.data['geopoint'];

    Map coordinates = Map();

    coordinates[0] = geoPoint.latitude;
    coordinates[1] = geoPoint.longitude;

    return CafeItem(
        documentID: doc.documentID,
        title: doc.data['title'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '',
        name: doc.data['name'] ?? '',
        geopoint: coordinates ?? '',
        contact: doc.data['contact'] ?? '',
        region: doc.data['region']);
  }

  Future<List<DocumentSnapshot>> getCommentSnapshotList(CafeItem item) async {
    QuerySnapshot qshot = await Firestore.instance
        .collection('SampleCollection')
        .document(item.documentID)
        .collection('Comments')
        .getDocuments();

    return qshot.documents;
  }

  List<Comment> deriveCommentList(List<DocumentSnapshot> list) {
    return list.map((doc) => deriveComment(doc)).toList();
  }

  Comment deriveComment(DocumentSnapshot doc) {
    Timestamp timestamp = doc.data['timestamp'];

    return Comment(
        ID: doc.data['ID'] ?? '',
        comment: doc.data['comment'] ?? '',
        score: double.parse(doc.data['score'].toString()) ?? '',
        timestamp: timestamp.toDate() ?? '',
        photoUrl: doc.data['photoUrl']);
  }

  void addDemoDocument(documentId, data) async {
    await _db
        .collection('SampleCollection')
        .document(documentId)
        .collection("Comments")
        .add(data);
  }
}
