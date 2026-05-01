import 'package:xml/xml.dart';
import 'media_item.dart';

class Moment {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<MediaItem> medias;

  const Moment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.medias,
  });

  //check if a first image is present, if not return null
  MediaItem? get firstImage => medias.isNotEmpty ? medias.first : null;

  //parse the XML element to create a Moment instance
  factory Moment.fromXml(XmlElement xml) {
    final mediasNode = xml.findAllElements('medias').firstOrNull;
    final mediaNodes = mediasNode?.findElements('item').toList() ?? [];

    final mediaItems = mediaNodes
        .map((node) => MediaItem.fromXml(node))
        .where((m) => m.url.isNotEmpty)
        .toList();

    return Moment(
      id: xml.findElements('id').firstOrNull?.innerText ?? '',
      title: xml.findElements('title').firstOrNull?.innerText ?? '',
      subtitle: xml.findElements('subtitle').firstOrNull?.innerText ?? '',
      description: xml.findElements('description').firstOrNull?.innerText ?? '',
      medias: mediaItems,
    );
  }
}
