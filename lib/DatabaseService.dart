import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'dart:async';
import 'models/ItemDetail.dart';


class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<CafeItem>> streamCafeList() {
    return _db
        .collection('SampleCollection')
        .snapshots()
        .map(
            (list) =>
            list.documents
                .map((doc) => CafeItem.fromFirestore(doc)).toList());
  }

  Stream<QuerySnapshot> streamItemDetail(CafeItem item) {
    return _db
        .collection("SampleCollection")
        .document(item.documentID)
        .collection('Comments')
        .snapshots();
  }

  List<ItemDetail> mapItemDetail(snapshot) {
    snapshot.map((event) =>
        (list) =>
        list.documents
            .map((doc) => ItemDetail.fromFirestore(doc)).toList());
  }

 Future<List<DocumentSnapshot>> getItemDetailList(CafeItem item) async {

    QuerySnapshot qshot =
    await Firestore.instance
        .collection('SampleCollection').document(item.documentID).collection('Comments').getDocuments();

    return qshot.documents;


  }
}
