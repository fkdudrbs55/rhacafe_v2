import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'V6ANRWWF6Y', //ApplicationID
    apiKey: 'f7e7431412856392e357989c015e80eb', //search-only api key in flutter code
  );
}