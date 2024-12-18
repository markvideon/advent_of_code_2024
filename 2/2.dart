import 'package:collection/collection.dart';
import 'dart:io';

void main() {
  final list = parseFile();
  int safeReports = 0;
  list.forEach((report) {
    if (isSafeReport2(report)) {
      safeReports++;
    }
  });
  print('Safe reports: $safeReports');
}

List<List<int>> parseFile() {
  final result = <List<int>>[];
  final file = File('file');
  final lines = file.readAsLinesSync();
  lines.forEach((line) {
    final candidates = line.split(' ');
    result.add(
      candidates.map((e) => int.parse(e))
          .toList(growable: false),
    );
  });

  return result;
}

bool isSafeReport1(List<int> report) {
  int sign = (report[1] - report[0]).sign;
  var isMonotonic = true;
  var differenceInRange = true;

  for (int i = 1; i < report.length; i++) {
    final thisDifference = report[i] - report[i-1];
    // Check whether always increasing, exit early
    // if it isn't.
    isMonotonic = sign == thisDifference.sign;

    if (!isMonotonic) {
      break;
    }

    // Check if the difference is within the
    // expected range. Exit early if it isn't.
    final absoluteDifference = thisDifference.abs();
    differenceInRange =
      absoluteDifference >= 1 &&
      absoluteDifference <= 3;

    if (!differenceInRange) {
      break;
    }
  }

  return differenceInRange && isMonotonic;
}

bool isSafeReport2(List<int> report) {
  final ogReport = isSafeReport1(report);

  if (ogReport) {
    return true;
  } else {
    for (int i = 0; i < report.length; i++) {
      final withoutThisIdx = isSafeReport1(
          report.whereNotIndexed((idx, value) => idx == i)
              .toList(growable: false)
      );

      if (withoutThisIdx) {
        return true;
      }
    }

    return false;
  }
}
