import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import '../../CONSTANTS.dart' as Constants;
import '../../utils/cupertinoSwitchListTile.dart';
import '../../utils/navigator_pop.dart';
import '../Settings%20part/AboutPage.dart';
import '../Settings%20part/NotificationSettingPage.dart';
import '../Settings%20part/settingsProvider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String timeFormat;

  @override
  void initState() {
    super.initState();
    timeFormat =
        GetStorage().read(Constants.kStoredTimeIs12) ? '12 hour' : '24 hour';
    print(timeFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingProvider>(
        builder: (context, setting, child) {
          return ListView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Display')),
              buildTimeFormat(setting),
              SizedBox(height: 3),
              buildShowOtherPrayerTime(setting),
              SizedBox(height: 3),
              buildFontSizeSetting(setting),
              SizedBox(height: 3),
              buildHijriOffset(setting),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Notification')),
              buildNotificationSetting(context),
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Sharing')),
              buildSharingSetting(setting),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('More')),
              buildAboutApp(context),
              SizedBox(height: 3),
              setting.isDeveloperOption
                  ? buildVerboseDebugMode(context)
                  : SizedBox.shrink(),
              SizedBox(height: 3),
              setting.isDeveloperOption
                  ? buildResetAllSetting(context)
                  : SizedBox.shrink(),
              SizedBox(height: 40)
            ],
          );
        },
      ),
    );
  }

  Card buildHijriOffset(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Text('Hijri date offset'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size(5, 5),
                    backgroundColor: CupertinoColors.tertiarySystemFill),
                onPressed: setting.hijriOffset <= -2
                    ? null
                    : () => setting.hijriOffset--,
                child: FaIcon(FontAwesomeIcons.minus, size: 11)),
            Container(
              child: Text(
                  '${setting.hijriOffset} ${setting.hijriOffset == 1 ? 'day' : 'days'}'),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size(5, 5),
                    backgroundColor: CupertinoColors.tertiarySystemFill),
                onPressed: setting.hijriOffset >= 2
                    ? null
                    : () => setting.hijriOffset++,
                child: FaIcon(FontAwesomeIcons.plus, size: 11)),
          ],
        ),
      ),
    );
  }

  Card buildFontSizeSetting(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('Font size'),
        ),
        subtitle: Slider(
          activeColor: CupertinoColors.activeBlue,
          // inactiveColor: Colors.teal.withAlpha(40),
          label: setting.prayerFontSize.round().toString(),
          min: 12.0,
          max: 22.0,
          divisions: 5,
          value: setting.prayerFontSize,
          onChanged: (double value) {
            setting.prayerFontSize = value;
          },
        ),
      ),
    );
  }

  Card buildSharingSetting(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
          child: Text(
            'Specify the default behavior',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CupertinoSlidingSegmentedControl(
            groupValue: setting.sharingFormat,
            onValueChanged: (value) => setting.sharingFormat = value,
            children: {
              //defaulted to always ask
              0: Text('Always ask'),
              1: Text('Plain Text'),
              2: Text('WhatsApp'),
            },
          ),
        ),
      ),
    );
  }

  Card buildVerboseDebugMode(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Verbose debug mode'),
        subtitle: Text('For developer purposes'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(GetStorage().read(Constants.kIsDebugMode)
                    ? 'Verbose debug mode is ON'
                    : 'Verbose debug mode is OFF'),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content: Text(
                    'Toast message or similar will show throughout usage of the app'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        print('PROCEED');
                        //inverse if false then become true & vice versa
                        GetStorage().write(Constants.kIsDebugMode,
                            !GetStorage().read(Constants.kIsDebugMode));
                        CustomNavigatorPop.popTo(context, 2);
                      },
                      child: GetStorage().read(Constants.kIsDebugMode)
                          ? Text('Turn off')
                          : Text(
                              'Turn on',
                              style: TextStyle(color: Colors.red),
                            ))
                ],
              );
            },
          );
        },
      ),
    );
  }

  Card buildResetAllSetting(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Reset all setting'),
        subtitle: Text('Deletes all GetStorage() items'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content: Text('Proceed? The app will exit automatically.'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () => GetStorage().erase().then((value) => {
                            Fluttertoast.showToast(msg: 'Reset done'),
                            SystemNavigator.pop()
                          }),
                      child: Text(
                        'Yes. Reset all',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              );
            },
          );
        },
      ),
    );
  }

  Card buildAboutApp(BuildContext context) {
    return Card(
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.hasData)
            return ListTile(
              title: Text('About app (Ver. ${snapshot.data.version})'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutAppPage(snapshot.data),
                  ),
                );
              },
              subtitle: Text('Release Notes, Contribution, Twitter etc.'),
            );
          else
            return ListTile(
              leading: SizedBox(
                child: CircularProgressIndicator(),
              ),
            );
        },
      ),
    );
  }

  Card buildNotificationSetting(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Notification settings'),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NotificationPageSetting(),
            ),
          );
        },
      ),
    );
  }

  Card buildShowOtherPrayerTime(SettingProvider setting) {
    return Card(
      child: CupertinoSwitchListTile(
        activeColor: CupertinoColors.activeBlue,
        title: Text('Show other prayer times'),
        subtitle: Text('Imsak, Syuruk, Dhuha'),
        onChanged: (bool value) {
          setState(() {
            setting.showOtherPrayerTime = value;
            GetStorage().write(Constants.kStoredShowOtherPrayerTime, value);
          });
        },
        value: setting.showOtherPrayerTime,
      ),
    );
  }

  Card buildTimeFormat(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Text('Time format'),
        trailing: DropdownButton(
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FaIcon(FontAwesomeIcons.caretDown, size: 13),
          ),
          items: <String>['12 hour', '24 hour']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            var is12 = newValue == '12 hour';
            // print('NewValue $newValue');
            setting.use12hour = is12;
            GetStorage().write(Constants.kStoredTimeIs12, is12);
            setState(() {
              timeFormat = newValue;
              print(GetStorage().read(Constants.kStoredTimeIs12));
            });
          },
          value: timeFormat,
        ),
      ),
    );
  }
}
