import 'package:flutter/cupertino.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';

class CafeCatalogViewModel {
  List<CafeItem> _cafeItemList;

  setCafeItem(List<CafeItem> cafeItemList){
    _cafeItemList = cafeItemList;
  }

  List<CafeItem> get cafeItemList => _cafeItemList;

}