
import 'package:intl/intl.dart';

class DatetimeUtils {

  static String timestampToDateStr(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('MM/dd').format(dt);
  }

  static String timestampToTimeStr(int timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(dt);
  }
}