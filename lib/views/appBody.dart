import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/utils/sizeconfig.dart';

import 'GetPrayerTime.dart';
import 'ZoneChooser.dart';

class AppBody extends StatelessWidget {
  final _today = HijriCalendar.now();
  // final DateTime date = DateTime.now();
  final dayFormat = DateFormat('EEEE').format(DateTime.now());
  final dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight / 6,
            decoration: BoxDecoration(
              color: Colors.cyan.shade900,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(70),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    dayFormat,
                                    style: GoogleFonts.spartan(
                                        color: Colors.white),
                                  ),
                                  Text(
                                    _today.toFormat("dd MMMM yyyy"),
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    dateFormat,
                                    style:
                                        TextStyle(color: Colors.teal.shade100),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(18.0),
                        child: LocationChooser(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight / 69,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.screenWidth / 10, 8.0,
                SizeConfig.screenWidth / 10, 8.0),
            child: GetPrayerTime(),
          ),
          SizedBox(
            height: SizeConfig.screenHeight / 45,
          )
        ],
      ),
    );
  }
}