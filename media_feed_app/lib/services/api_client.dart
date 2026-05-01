import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<({String body, Map<String, String> headers})> fetchFeed({
    String? paginationTag,
  }) async {
    //request building
    const baseUrl = 'https://pbapi.forwen.com/v5/moments';

    //only refresh if no pagination tag (first page)
    final isRefresh = (paginationTag == null || paginationTag.isEmpty)
        ? '1'
        : '0';

    final queryParams = 'refresh=$isRefresh&type=0&auth=0&per_page=8';
    final uri = Uri.parse('$baseUrl?$queryParams');

    final requestHeaders = <String, String>{'Accept': 'application/xml'};

    if (paginationTag != null && paginationTag.isNotEmpty) {
      requestHeaders['Tag'] = paginationTag;
    }

    final response = await _client.get(uri, headers: requestHeaders);

    //throw exception if response not successful
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    return (body: response.body, headers: response.headers);
  }

  void dispose() => _client.close();
}

//custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
