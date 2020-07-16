import 'package:cloud_firestore/cloud_firestore.dart';

class CafeItem {
  final String documentID;
  final String title;
  final String imageUrl;
  final String location;
  final String subtitle;
  final String content;

  CafeItem(
      {this.documentID,
      this.title,
      this.imageUrl,
      this.location,
      this.subtitle,
      this.content});

  factory CafeItem.fromFirestore(DocumentSnapshot doc) {
    return CafeItem(
        documentID: doc.documentID,
        title: doc.data['title'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        location: doc.data['location'] ?? '',
        subtitle: doc.data['subtitle'] ?? '',
        content: doc.data['content'] ?? '');
  }
}
