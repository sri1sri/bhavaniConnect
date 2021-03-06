import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateFormat _monthYearFormat = new DateFormat("MMMM yyyy");
  static final DateFormat _dayFormat = new DateFormat("dd");
  static final DateFormat monthDayYearFormat = new DateFormat("MMM dd, yyyy");
  static final DateFormat _firstDayFormat = new DateFormat("MMM dd");
  static final DateFormat _dayMonthYearFormat = new DateFormat("dd MMM yyyy");
  static final DateFormat _weekDayFormat = new DateFormat("EEEE");
  static final DateFormat _dayMonthYearTimeFormat =
      new DateFormat("dd MMM yyyy H:mm a");
  static final DateFormat _fullDayFormat = new DateFormat("EEE MMM dd, yyyy");
  static final DateFormat _apiDayFormat = new DateFormat("yyyy-MM-dd");
  static final DateFormat _monthDaytimeFormat =
      new DateFormat("MMM dd, H:mm a");
  static final DateFormat _hourMinuteFormat = new DateFormat().add_jm();
  static final DateFormat _dotDateFormat = new DateFormat('dd.MM.yyy');
  static final DateFormat _slashDateFormat = new DateFormat('dd/MMM/yyyy');
  static final DateFormat _dayMonthFormat = new DateFormat("dd MMMM");
  static final DateFormat _monthFormat = new DateFormat("MMMM");
  static final DateFormat _monthAbbrFormat = new DateFormat("MMM");
  static final DateFormat _yearFormat = new DateFormat("yyyy");
  static final DateFormat _hourMinuteDifferenceFormat = new DateFormat("hh:mm");

  static String formatMonthYear(DateTime d) => _monthYearFormat.format(d);
  static String formatDayMonthYear(DateTime d) => _dayMonthYearFormat.format(d);
  static String formatDay(DateTime d) => _dayFormat.format(d);
  static String formatMonthDayYear(DateTime d) => monthDayYearFormat.format(d);
  static String formatFirstDay(DateTime d) => _firstDayFormat.format(d);
  static String formatMonth(DateTime d) => _monthFormat.format(d);
  static String formatAbbrMonth(DateTime d) => _monthAbbrFormat.format(d);
  static String fullDayFormat(DateTime d) => _fullDayFormat.format(d);
  static String weekDayFormat(DateTime d) => _weekDayFormat.format(d);
  static String apiDayFormat(DateTime d) => _apiDayFormat.format(d);
  static String monthDayTimeFormat(DateTime d) => _monthDaytimeFormat.format(d);
  static String hourMinuteFormat(DateTime d) => _hourMinuteFormat.format(d);
  static String hourMinuteDifferenceFormat(DateTime d) =>
      _hourMinuteDifferenceFormat.format(d);
  static String slashDateFormat(DateTime d) => _slashDateFormat.format(d);
  static String dotDateFormat(DateTime d) => _dotDateFormat.format(d);
  static String dayMonthFormat(DateTime d) => _dayMonthFormat.format(d);
  static String dayMonthYearTimeFormat(DateTime d) =>
      _dayMonthYearTimeFormat.format(d);
  static String yearFormat(DateTime d) => _yearFormat.format(d);

  static const List<String> weekdays = const [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  ];

  static const List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static int weekOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static bool hasSameWeek(DateTime date1, DateTime date2) {
    if (date1 == null || date2 == null) return false;

    if (date1.year == date2.year) {
      return weekOfYear(date1) == weekOfYear(date2);
    } else {
      var lowerDate = date1;
      var higherDate = date2;
      if (higherDate.difference(lowerDate).isNegative) {
        lowerDate = date2;
        higherDate = date1;
      }

      var firstDayOfWeek = DateTimeUtils.firstDayOfWeek(lowerDate);
      var diff = higherDate.difference(firstDayOfWeek).inDays;
      return diff.abs() < 7;
    }
  }

  static bool isFirstDayOfMonth(DateTime day) {
    return isSameDay(firstDayOfMonth(day), day);
  }

  static bool isLastDayOfMonth(DateTime day) {
    return isSameDay(lastDayOfMonth(day), day);
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return new DateTime(month.year, month.month);
  }

  static DateTime firstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Sunday - Monday
    var decreaseNum = day.weekday % 7;
    return day.subtract(new Duration(days: decreaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Sunday
    var increaseNum = day.weekday % 7;
    return day.add(new Duration(days: 7 - increaseNum));
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(new Duration(days: 1));
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    a = new DateTime.utc(a.year, a.month, a.day);
    b = new DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday % 7 - min.weekday % 7 >= 0;
    return result;
  }

  static DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return new DateTime(year, month);
  }

  static DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return new DateTime(year, month);
  }

  static String getDifferenceTime(DateTime d1, DateTime d2) {
    int diff = d2.toUtc().difference(d1.toUtc()).inMilliseconds;
    print(d1.millisecondsSinceEpoch - d2.millisecondsSinceEpoch);
    print(d1.millisecondsSinceEpoch);
    print(d2.millisecondsSinceEpoch);
    print(diff);
    if (diff >= 0) {
      var result;
      var seconds = diff / 1000;
      var hours = 0;
      var minutes = 0;
      var newMinutes = '';
      hours = (seconds / 3600).floor();
      minutes = ((seconds % 3600) / 60).floor();
      if (minutes < 10) {
        newMinutes = minutes.toString().padLeft(2, '0');
      } else {
        newMinutes = minutes.toString();
      }
      return "$hours:$newMinutes";
    } else {
      return "-";
    }
  }

  static DateTime previousWeek(DateTime w) {
    return w.subtract(new Duration(days: 7));
  }

  static DateTime nextWeek(DateTime w) {
    return w.add(new Duration(days: 7));
  }

  static String currentMonth = DateFormat.M().format(DateTime.now().toUtc());

  static String currentYear = DateFormat.y().format(DateTime.now().toUtc());

  static String currentday = DateFormat.d().format(DateTime.now().toUtc());

  static String hour = DateFormat.H().format(DateTime.now().toUtc());

  static String minute = DateFormat.m().format(DateTime.now().toUtc());

  static String second = DateFormat.s().format(DateTime.now().toUtc());

  static int timestamp = new DateTime.now().toUtc().millisecondsSinceEpoch;

  static DateTime currentDayDateTime = DateTime(
      int.parse(currentYear), int.parse(currentMonth), int.parse(currentday));

  static DateTime currentDayDateTimeNow =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  static int todayUtcTimestamp = new DateTime.utc(int.parse(currentYear),
          int.parse(currentMonth), int.parse(currentday))
      .millisecondsSinceEpoch;

  static dateOnly(DateTime selectedDay) =>
      DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

  static String toNaturalDate(Timestamp timestamp) {
    var _clock = DateTime.now();
    var elapsed =
        _clock.millisecondsSinceEpoch - timestamp.millisecondsSinceEpoch;
    String suffix;

    if (elapsed < 0) {
      elapsed = -elapsed;
      suffix = 'from now';
    } else {
      suffix = 'ago';
    }

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45)
      result = 'a moment';
    else if (seconds < 90)
      result = 'a minute';
    else if (minutes < 45)
      result = "${minutes.round()} minutes";
    else if (minutes < 90)
      result = 'about an hour';
    else if (hours < 24)
      result = '${hours.round()} hours';
    else if (hours < 48)
      result = 'a day';
    else if (days < 30)
      result = "${days.round()} days";
    else if (days < 60)
      result = 'about a month';
    else if (days < 365)
      result = "${months.round()} months";
    else if (years < 2)
      result = 'about a year';
    else
      result = "${years.round()} years";

    return "$result $suffix";
  }

  static int daysInMonth(int monthNum, int year) {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }

  static leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }
}
