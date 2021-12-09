import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

class MyClient extends http.BaseClient {
  User _user = userRepo.currentUser.value;
  http.Client _httpClient = new http.Client();

  MyClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final Map<String, String> defaultHeaders = {
      "Authorization": "${_user.apiToken}",
    };
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
