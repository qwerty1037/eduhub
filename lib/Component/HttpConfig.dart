import 'package:front_end/Component/Cookie.dart';

enum httpContentType {
  json,
  multipart,
}

Future<Map<String, String>> defaultHeader(httpContentType type) async {
  Map<String, String> header = await sendCookieToBackend();
  if (type == httpContentType.json) {
    header.addAll({"Content-type": "application/json"});
  } else if (type == httpContentType.multipart) {
    header.addAll({"Content-type": "multipart/form-data"});
  }
  return header;
}
