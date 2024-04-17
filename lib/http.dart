import 'dart:convert';

import 'package:http/http.dart' as http;

String base="http://124.221.108.135:5000";
Future<String> httpGet(String uri) async {
  return await http.read(Uri.parse(base+uri));
}
dynamic httpGetJson(String uri)async{
  return await jsonDecode(await httpGet(uri));
}