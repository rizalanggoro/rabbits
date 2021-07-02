import 'package:flutter/material.dart';
import 'package:rabbits/data/calendar_data.dart';

class Util {
  MediaQueryData? _mediaQueryData;
  TextTheme? _textTheme;

  void init(BuildContext context) {
    _mediaQueryData ??= MediaQuery.of(context);
    _textTheme ??= Theme.of(context).textTheme;
  }

  TextTheme get textTheme => _textTheme!;
  EdgeInsets get padding => _mediaQueryData!.padding;

  String get generateKey {
    var _a = DateTime.now();
    return _a.toString();
  }

  String parseDate(String? date, {String? error}) {
    var _date = error ?? '-';
    if (date != null && date.isNotEmpty) {
      var _dateTime = DateTime.parse(date);
      var _year = _dateTime.year;
      var _month = CalendarData.month[_dateTime.month - 1];
      var _day = _dateTime.day;
      var _weekDay = CalendarData.days[_dateTime.weekday];
      _date = '$_weekDay, $_day $_month $_year';
    }
    return _date;
  }
}
