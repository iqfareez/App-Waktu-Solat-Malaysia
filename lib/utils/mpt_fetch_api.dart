import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../CONSTANTS.dart';
import '../models/mpti906PrayerData.dart';

class MptApiFetch {
  static Future<Mpti906PrayerModel> fetchMpt(String location) async {
    final api = Uri.https('mpt.i906.my', 'api/prayer/$location');
    try {
      final response = await http.get(api);
      GetStorage()
          .write(kStoredApiPrayerCall, api.toString()); //for debug dialog
      if (GetStorage().read(kIsDebugMode)) {
        Fluttertoast.showToast(msg: api.toString());
      }

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Mpti906PrayerModel.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw 'Failed to load prayer time. Status code ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection.';
    }
  }
}
