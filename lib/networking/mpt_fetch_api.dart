import 'dart:convert';

import 'package:waktusolatmalaysia/models/mpti906PrayerData.dart';
import 'package:http/http.dart' as http;

class MptApiFetch {
  static Future<Mpti906PrayerModel> fetchMpt(String location) async {
    final api = Uri.https('mpt.i906.my', 'api/prayer/$location');
    final response = await http.get(api);
    print(api);
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Mpti906PrayerModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
