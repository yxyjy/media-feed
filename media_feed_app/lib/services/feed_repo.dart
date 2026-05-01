import 'package:xml/xml.dart';
import '../models/moment.dart';
import 'api_client.dart';

class FeedResult {
  final List<Moment> moments;
  final String? nextTag;
  const FeedResult({required this.moments, this.nextTag});
}

class FeedRepository {
  final ApiClient _apiClient;
  const FeedRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<FeedResult> fetchPage({String? tag}) async {
    final response = await _apiClient.fetchFeed(paginationTag: tag);
    final document = XmlDocument.parse(response.body);

    final itemNodes = document.rootElement.findElements('item').toList();

    final moments = itemNodes
        .map((node) => Moment.fromXml(node))
        .where((m) => m.id.isNotEmpty)
        .toList();

    final nextTag = response.headers['tag'];

    return FeedResult(moments: moments, nextTag: nextTag);
  }
}
