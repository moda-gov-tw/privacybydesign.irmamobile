import 'package:intl/intl.dart';

String formatDate(DateTime date, String lang) {
  return DateFormat.yMMMMd(lang).addPattern(" - ").add_jm().format(date);
}

String printableDate(DateTime date, String lang) {
  return DateFormat.yMMMMd(lang).format(date);
}
