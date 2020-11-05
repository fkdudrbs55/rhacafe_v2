import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/services/AlgoliaApplication.dart';
import 'dart:async';
import '../models/Comment.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final Algolia _algolia = AlgoliaApplication.algolia;

  //TODO Firebase에서 업데이트 됐을 때 해당 내용이 Algolia에 반영되도록 조정
  Future<List<AlgoliaObjectSnapshot>> getAlgoliaCafeSnapshotList(
    String input,
  ) async {
    AlgoliaQuery query = _algolia.instance.index("dev_rhacafe").search(input);

    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();

    List<AlgoliaObjectSnapshot> results = querySnapshot.hits;

    return results;
  }

  List<CafeItem> deriveCafeListFromAlgolia(List<AlgoliaObjectSnapshot> list) {
    print("deriveCafeItemFromAlgolia null? ${list == null}");

    return list.map((doc) => deriveCafeItemFromAlgoliaSnapshot(doc)).toList();
  }

  CafeItem deriveCafeItemFromAlgoliaSnapshot(AlgoliaObjectSnapshot doc) {
    print("deriveCafeItemFromAlgoliaSnapshot null? ${doc == null}");

    Map timestampMap = doc.data['timestamp'];

    Timestamp timestamp = Timestamp(
        timestampMap.values.toList()[0], timestampMap.values.toList()[1]);

    List<String> imageUrls = List<String>.from(doc.data['imageUrl']);

    return CafeItem(
        documentID: doc.objectID,
        title: doc.data['title'] ?? '',
        imageUrl: imageUrls ?? '',
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '',
        name: doc.data['name'] ?? '',
        geopoint: doc.data['geopoint'] ?? '',
        contact: doc.data['contact'] ?? '',
        timestamp: timestamp.toDate() ?? Timestamp.now());
  }

//  Stream<List<CafeItem>> streamCafeList(int limit, {String startID = "none"}) {
//    return _db.collection('SampleCollection').limit(limit).snapshots().map(
//        (list) => list.documents.map((doc) => deriveCafeItem(doc)).toList());
//  }

  Future<List<DocumentSnapshot>> getCafeSnapshotList(int limit,
      {DocumentSnapshot lastVisible}) async {
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

  List<CafeItem> deriveCafeListFromSnapshots(List<DocumentSnapshot> list) {
    if (list == null || list.length == 0) {
      return [];
    }

    return list.map((doc) => deriveCafeItem(doc)).toList();
  }

  CafeItem deriveCafeItem(DocumentSnapshot doc) {
    GeoPoint geoPoint = doc.data['geopoint'];

    Timestamp timestamp = doc.data['timestamp'];

    Map coordinates = Map();

    coordinates[0] = geoPoint.latitude;
    coordinates[1] = geoPoint.longitude;

    List<String> imageUrls = List<String>.from(doc.data['imageUrl']);

    return CafeItem(
        documentID: doc.documentID,
        title: doc.data['title'] ?? '',
        imageUrl: imageUrls ?? '',
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '',
        name: doc.data['name'] ?? '',
        geopoint: coordinates ?? '',
        contact: doc.data['contact'] ?? '',
        timestamp: timestamp.toDate() ?? Timestamp.now());
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
    if (list == null || list.length == 0) {
      return [];
    }

    return list.map((doc) => deriveComment(doc)).toList();
  }

  Comment deriveComment(DocumentSnapshot doc) {
    Timestamp timestamp = doc.data['timestamp'];

    return Comment(
        uid: doc.data['uid'] ?? '',
        username: doc.data['username'] ?? '',
        comment: doc.data['comment'] ?? '',
        score: double.parse(doc.data['score'].toString()) ?? '',
        timestamp: timestamp.toDate() ?? '',
        photoUrl: doc.data['photoUrl']);
  }

  void addComment(String documentID, Comment comment) {
    _db.collection('SampleCollection').document(documentID).collection('Comments').add({
      'uid': comment.uid,
      'username': comment.username,
      'comment': comment.comment,
      'score': comment.score,
      'timestamp': Timestamp.now(),
      'photoUrl': comment.photoUrl
    }).then((value) => print(value.documentID)).catchError(
        (onError) => print('Failed to add comment because of $onError'));
  }
}
