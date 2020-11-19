class CafeItem {
  final String documentID;
  final String title;
  final List<String> imageUrl;
  final String location;
  final String subtitle;
  final String content;
  final String name;
  final Map geopoint;
  final String contact;
  final DateTime timestamp;
  final List<double> scores;

  CafeItem({
    this.documentID,
    this.title,
    this.imageUrl,
    this.location,
    this.subtitle,
    this.content,
    this.name,
    this.geopoint,
    this.contact,
    this.timestamp,
    this.scores,
  });

  const CafeItem.constant(
      {this.documentID = '1',
      this.title = '1',
      this.imageUrl = const ['1', '2'],
      this.location: '0',
      this.subtitle: '1',
      this.content: 'a',
      this.name: 'b',
      this.geopoint: const {},
      this.contact: '1',
      this.timestamp: null,
      this.scores: const [0.0, 1.0]});
}
