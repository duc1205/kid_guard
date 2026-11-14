import 'package:intl/intl.dart';

/// 05:09 hoặc 1:05:09
String formatCountdown(Duration d) {
  if (d.isNegative) d = Duration.zero;
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

String formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

String formatDateTime(DateTime d) => DateFormat('HH:mm dd/MM/yyyy').format(d);

String formatTime(DateTime d) => DateFormat('HH:mm:ss').format(d);

const optionLetters = ['A', 'B', 'C', 'D'];
