import 'package:http/http.dart' as http;
import 'dart:convert';
Future<bool> verify(String email,String college) async {
  String url = 'http://universities.hipolabs.com/search?name=${college.toLowerCase()}';
  int atIndex = email.indexOf('@');
  String givenDomain = email.substring(atIndex + 1);
  var response = await http.get(Uri.parse(url));
  var data = jsonDecode(response.body);
  List<String> domains = List<String>.from(data[0]['domains']);
  bool match = false;
  for(String domain in domains){
  	if(domain == givenDomain)match = true;
  }
  return match;
}
