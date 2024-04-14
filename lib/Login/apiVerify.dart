import 'package:http/http.dart' as http;
import 'dart:convert';
Future<bool> verify(String email,String college) async {
  //convert college name into proper url by adding %20 for spaces
  college = college.replaceAll(' ', '%20');
  String url = 'http://universities.hipolabs.com/search?name=${college.toLowerCase()}';
  int atIndex = email.indexOf('@');
  String givenDomain = email.substring(atIndex + 1);
  if(givenDomain == 'sxcsccu.edu.in') return true; //TODO: Just for texting, remove this file in production
  // print('Given Domain: $givenDomain');
  var response = await http.get(Uri.parse(url));
  var data = jsonDecode(response.body);
  List<String> domains = List<String>.from(data[0]['domains']);
  // print('Domains: $domains');
  bool match = false;
  for(String domain in domains){
  	if(domain == givenDomain)match = true;
    // print('Domain: if');
  }
  return match;
}
