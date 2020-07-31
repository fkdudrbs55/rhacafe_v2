
class CafeItem {
  final String documentID;
  final String title;
  final String imageUrl;
  final String location;
  final String subtitle;
  final String content;
  final String name;
  final Map geopoint;
  final String contact;

  CafeItem(
      {this.documentID,
      this.title,
      this.imageUrl,
      this.location,
      this.subtitle,
      this.content,
      this.name,
      this.geopoint,
      this.contact});
}
