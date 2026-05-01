//to grab the first media URL

import 'package:xml/xml.dart';

class MediaItem {
  final String url;
  const MediaItem({required this.url});

  factory MediaItem.fromXml(XmlElement xml) {
    final url =
        xml.findAllElements('media_filename').firstOrNull?.innerText.trim() ??
        '';

    return MediaItem(url: url);
  }
}
