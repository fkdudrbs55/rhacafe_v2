import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rhacafe_v1/constants/ui.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/models/Comment.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';

class CafeNotifier extends ChangeNotifier {
  List<CafeItem> _cafeList = [];
  List<DocumentSnapshot> _snapshotList = [];

  addCafeToList(CafeItem item) {
    _cafeList.add(item);
    notifyListeners();
  }

  setCafeList(List<CafeItem> cafeList) {
    _cafeList = [];
    _cafeList = cafeList;
    notifyListeners();
  }

  DocumentSnapshot getLastVisible() {
    return _snapshotList[_snapshotList.length - 1];
  }

  addSnapshotsToList(List<DocumentSnapshot> update) {
    _snapshotList.addAll(update);
    notifyListeners();
  }

  setSnapshotList(List<DocumentSnapshot> snapshots) {
    _snapshotList = snapshots;
    notifyListeners();
  }

  List<CafeItem> getCafeList() {
    return _cafeList;
  }

  void uploadCafe(CafeItem item, Comment comment) {
    DatabaseService.addComment(item, comment);
  }

  List<DocumentSnapshot> getSnapshotList(){
    return _snapshotList;
  }
}
