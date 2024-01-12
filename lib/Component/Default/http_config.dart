import 'package:front_end/Component/cookie.dart';

enum httpContentType {
  json,
  multipart,
}

/// Return header of http Request
///
/// Argument: httpContentType(json, multipart...)
Future<Map<String, String>> defaultHeader(httpContentType type) async {
  Map<String, String> header = await sendCookieToBackend();
  if (type == httpContentType.json) {
    header.addAll({"Content-type": "application/json"});
  } else if (type == httpContentType.multipart) {
    // header.addAll({"Content-type": "multipart/form-data"});
  }
  return header;
}

/// if http request is success, response.statusCode will be 2xx
///
/// return true when request is success
bool isHttpRequestSuccess(response) {
  return response.statusCode ~/ 100 == 2;
}
