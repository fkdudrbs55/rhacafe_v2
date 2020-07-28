import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'dart:async';
import '../models/ItemDetail.dart';


class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<CafeItem>> streamCafeList() {
    return _db
        .collection('SampleCollection')
        .snapshots()
        .map(
            (list) =>
            list.documents
                .map((doc) => deriveCafeItem(doc)).toList());
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
        geopoint: coordinates);
  }

 Future<List<DocumentSnapshot>> getItemDetailSnapshotList(CafeItem item) async {

    QuerySnapshot qshot =
    await Firestore.instance
        .collection('SampleCollection').document(item.documentID).collection('Comments').getDocuments();

    return qshot.documents;
  }

  ItemDetail deriveItemDetail(DocumentSnapshot doc) {

    Timestamp timestamp = doc.data['timestamp'];

    return ItemDetail(
        ID: doc.data['ID'] ?? '',
        comment: doc.data['comment'] ?? '',
        score: doc.data['score'] ?? '',
        timestamp: timestamp.toDate() ?? ''
    );
  }
}
