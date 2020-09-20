import 'dart:async';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';
import 'package:waktusolatmalaysia/repository/azanpro_repository.dart';

class AzanproBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;
  bool _isStreaming;

  StreamSink<Response<AzanPro>> get prayDataSink => _prayDataController.sink;

  Stream<Response<AzanPro>> get prayDataStream => _prayDataController.stream;

  AzanproBloc(String category, String format) {
    _prayDataController = StreamController<Response<AzanPro>>();
    _prayerTimeRepository = AzanTimesTodayRepository();
    _isStreaming = true;
    format = format == null ? '' : format;
    // fetchPrayerTime(category, format);
  }

  fetchPrayerTime(String category, String format) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      AzanPro prayerTime =
          await _prayerTimeRepository.fetchAzanToday(category, format);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e.toString());
    }
  }

  dispose() {
    _isStreaming = false;
    _prayDataController?.close();
  }
}
