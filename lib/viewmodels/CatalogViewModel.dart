import 'package:flutter/cupertino.dart';
import 'package:rhacafe_v1/models/CafeItem.dart';
import 'package:rhacafe_v1/services/DatabaseService.dart';

class CatalogViewModel extends ChangeNotifier{

  static const int ItemRequestThreshold = 5;

  List<CafeItem> _items;
  List<CafeItem> get items => _items;
  DatabaseService _db = DatabaseService();

  static const String LoadingIndicatorTitle = '^';

//  Future handleItemCreated(int index) async {
//    var itemPosition = index + 1;
//    var requestMoreData =
//        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
//    var pageToRequest = itemPosition ~/ ItemRequestThreshold;
//
//    if (requestMoreData && pageToRequest > _currentPage) {
//      print('handleItemCreated | pageToRequest: $pageToRequest');
//      _currentPage = pageToRequest;
//      _showLoadingIndicator();
//
//      await Future.delayed(Duration(seconds: 5));
//      var newFetchedItems = List<String>.generate(
//          15, (index) => 'Title page:$_currentPage item: $index');
//      _items.addAll(newFetchedItems);
//
//      _removeLoadingIndicator();
//    }
//  }

//  void _showLoadingIndicator() {
//    _items.add(LoadingIndicatorTitle);
//    notifyListeners();
//  }
//
//  void _removeLoadingIndicator() {
//    _items.remove(LoadingIndicatorTitle);
//    notifyListeners();
//  }
}