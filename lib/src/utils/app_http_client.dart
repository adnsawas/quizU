import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class AppHttpClient extends BaseClient {
  final Client _client = Client();
  String? accessToken;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // Every http request is intercepted and [accessToken] is inserted
    // as header if available
    if (accessToken != null) {
      request.headers
          .addAll({HttpHeaders.authorizationHeader: 'Bearer ${accessToken!}'});
    }
    return _client.send(request);
  }
}

/// The [Provider] that provides the [AppHttpClient] for all repositories
/// in the app
final appHttpClientProvider = Provider<AppHttpClient>((ref) => AppHttpClient());
