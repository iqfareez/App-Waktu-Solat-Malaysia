//If less than 3 days, since the last notif is scheduled, do not rescehdule
//3 days = 259200000 millis
//15 seconds = 15000
//4 hours = 14400000
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class PreventUpdatingNotifs {
  static void now() {
    if ((DateTime.now().millisecondsSinceEpoch -
            GetStorage().read(kStoredLastUpdateNotif)) <
        14400000) {
      print('Notification should not update');
      //TODO: Remove when release, toast is for debug purposes
      Fluttertoast.showToast(msg: 'Notification should not update');
      GetStorage().write(kStoredShouldUpdateNotif, false);
    } else {
      GetStorage().write(kStoredShouldUpdateNotif, true);
      print('Notification should update');
      Fluttertoast.showToast(msg: 'Notification should update');
    }
  }
}