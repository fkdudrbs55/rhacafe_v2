import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/notifiers/CafeNotifier.dart';
import 'package:rhacafe_v1/services/AlgoliaApplication.dart';
import 'dart:async';
import '../models/Comment.dart';

class DatabaseService {
  //TODO Firebase에서 업데이트 됐을 때 해당 내용이 Algolia에 반영되도록 조정
  static Future<List<AlgoliaObjectSnapshot>> getAlgoliaCafeSnapshotList(
      String input, int page) async {
    Algolia _algolia = AlgoliaApplication.algolia;

//    AlgoliaQuery query = _algolia.instance.index("dev_rhacafe").search(input).setLength(limit);
//
//    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();

    AlgoliaQuerySnapshot qshot = await _algolia.instance
        .index("dev_rhacafe")
        .search(input)
        .setHitsPerPage(8)
        .setPage(page)
        .getObjects();

    return qshot.hits;
  }

  static List<CafeItem> deriveCafeListFromAlgolia(
      List<AlgoliaObjectSnapshot> list) {
    print("deriveCafeItemFromAlgolia null? ${list == null}");

    return list.map((doc) => deriveCafeItemFromAlgoliaSnapshot(doc)).toList();
  }

  //TODO 아니 왜 Catalog에서는 문제 없는데 여기서 계속 문제가 생겼을까? 우선 대충은 해결
  static CafeItem deriveCafeItemFromAlgoliaSnapshot(AlgoliaObjectSnapshot doc) {
    print("deriveCafeItemFromAlgoliaSnapshot null? ${doc == null}");

    Map timestampMap = doc.data['timestamp'];

    Timestamp timestamp = Timestamp(
        timestampMap.values.toList()[0], timestampMap.values.toList()[1]);

    List<String> imageUrls = List<String>.from(doc.data['imageUrl']);

    List<double> scores = [];
    List<dynamic> scoresDynamic = doc.data['scores'] ?? [];

    if (doc.data['scores'] != null) {
      for (int i = 0; i < scoresDynamic.length; i++) {
        scores.add(double.parse(scoresDynamic.elementAt(i).toString()));
      }
    }

    return CafeItem(
        documentID: doc.objectID,
        title: doc.data['title'] ?? '',
        imageUrl: imageUrls ?? [],
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '',
        name: doc.data['name'] ?? '',
        geopoint: doc.data['geopoint'] ?? '',
        contact: doc.data['contact'] ?? '',
        timestamp: timestamp.toDate() ?? Timestamp.now(),
        scores: scores);
  }

//  Stream<List<CafeItem>> streamCafeList(int limit, {String startID = "none"}) {
//   return _db.collection('SampleCollection').limit(limit).snapshots().map(
//        (list) => list.documents.map((doc) => deriveCafeItem(doc)).toList());
//  }

  static getCafeList(CafeNotifier cafeNotifier, int limit) async {
    List<CafeItem> cafeList = [];

    //TODO Try catch
    List<DocumentSnapshot> snapshotList = await getCafeSnapshotList(limit);

    cafeList = deriveCafeListFromSnapshots(snapshotList);

    cafeNotifier.setCafeList(cafeList);
    cafeNotifier.setSnapshotList(snapshotList);
  }

  static getUpdatedCafeList(CafeNotifier cafeNotifier,
      int limit, DocumentSnapshot lastVisible) async {

    QuerySnapshot qshot = await Firestore.instance
        .collection('SampleCollection')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastVisible)
        .limit(limit)
        .getDocuments();

    cafeNotifier.addSnapshotsToList(qshot.documents);
    cafeNotifier.setCafeList(deriveCafeListFromSnapshots(cafeNotifier.getSnapshotList()));
  }

  static Future<List<DocumentSnapshot>> getCafeSnapshotList(int limit,
      {DocumentSnapshot lastVisible}) async {
    Firestore _db = Firestore.instance;

    QuerySnapshot qshot;

    if (lastVisible != null) {
      qshot = await _db
          .collection('SampleCollection')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastVisible)
          .limit(limit)
          .getDocuments();
    } else {
      qshot = await _db
          .collection('SampleCollection')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .getDocuments();
    }
    return qshot.documents;
  }

  static List<CafeItem> deriveCafeListFromSnapshots(
      List<DocumentSnapshot> list) {
    if (list == null || list.length == 0) {
      return [];
    }

    return list.map((doc) => deriveCafeItem(doc)).toList();
  }

  static CafeItem deriveCafeItem(DocumentSnapshot doc) {
    GeoPoint geoPoint = doc.data['geopoint'];

    Timestamp timestamp = doc.data['timestamp'];

    Map coordinates = Map();

    coordinates[0] = geoPoint.latitude;
    coordinates[1] = geoPoint.longitude;

    List<String> imageUrls = List<String>.from(doc.data['imageUrl']);

    List<double> scores;

    if (doc.data['scores'] != null) {
      scores = List<double>.from(doc.data['scores']);
    } else {
      scores = [];
    }

    return CafeItem(
        documentID: doc.documentID,
        title: doc.data['title'] ?? '',
        imageUrl: imageUrls ?? [],
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '',
        name: doc.data['name'] ?? '',
        geopoint: coordinates ?? '',
        contact: doc.data['contact'] ?? '',
        timestamp: timestamp.toDate() ?? Timestamp.now(),
        scores: scores);
  }

  static Future<List<DocumentSnapshot>> getCommentSnapshotList(
      CafeItem item) async {
    QuerySnapshot qshot = await Firestore.instance
        .collection('SampleCollection')
        .document(item.documentID)
        .collection('Comments')
        .getDocuments();

    return qshot.documents;
  }

  static List<Comment> deriveCommentList(List<DocumentSnapshot> list) {
    if (list == null || list.length == 0) {
      return [];
    }

    return list.map((doc) => deriveComment(doc)).toList();
  }

  static Comment deriveComment(DocumentSnapshot doc) {
    Timestamp timestamp = doc.data['timestamp'];

    return Comment(
        uid: doc.data['uid'] ?? '',
        username: doc.data['username'] ?? '',
        comment: doc.data['comment'] ?? '',
        score: double.parse(doc.data['score'].toString()) ?? '',
        timestamp: timestamp.toDate() ?? '',
        photoUrl: doc.data['photoUrl']);
  }

  static void addComment(CafeItem item, Comment comment) {
    Firestore _db = Firestore.instance;

    print(item.scores.length);

    item.scores.add(comment.score.toDouble());

    print(item.scores.length);

    _db
        .collection('SampleCollection')
        .document(item.documentID)
        .updateData({'scores': FieldValue.arrayUnion(item.scores)});

    _db
        .collection('SampleCollection')
        .document(item.documentID)
        .collection('Comments')
        .add({
          'uid': comment.uid,
          'username': comment.username,
          'comment': comment.comment,
          'score': comment.score,
          'timestamp': Timestamp.now(),
          'photoUrl': comment.photoUrl
        })
        .then((value) => print(value.documentID))
        .catchError(
            (onError) => print('Failed to add comment because of $onError'));
  }
}
