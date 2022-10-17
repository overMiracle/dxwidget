// Copyright (c) 2016, Agilord. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

final _whitespacesRegExp = RegExp('\\s+');

/// A task may return a Future to indicate when it is completed. If it wouldn't
/// complete before [DxCrontab] calls it again, it will be delayed.
typedef Task = FutureOr<dynamic> Function();

/// A DxCrontab-like time-based job scheduler.
abstract class DxCrontab {
  /// A DxCrontab-like time-based job scheduler.
  factory DxCrontab() => _DxCrontab();

  /// Schedules a [task] running specified by the [schedule].
  ScheduledTask schedule(Schedule schedule, Task task);

  /// Closes the DxCrontab instance and doesn't accept new tasks anymore.
  Future close();
}

/// The DxCrontab schedule.
class Schedule {
  /// The seconds a Task should be started.
  final List<int>? seconds;

  /// The minutes a Task should be started.
  final List<int>? minutes;

  /// The hours a Task should be started.
  final List<int>? hours;

  /// The days a Task should be started.
  final List<int>? days;

  /// The months a Task should be started.
  final List<int>? months;

  /// The weekdays a Task should be started.
  final List<int>? weekdays;

  /// Test if this schedule should run at the specified time.
  bool shouldRunAt(DateTime time) {
    if (seconds?.contains(time.second) == false) return false;
    if (minutes?.contains(time.minute) == false) return false;
    if (hours?.contains(time.hour) == false) return false;
    if (days?.contains(time.day) == false) return false;
    if (weekdays?.contains(time.weekday) == false) return false;
    if (months?.contains(time.month) == false) return false;
    return true;
  }

  factory Schedule({
    /// The seconds a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic seconds,

    /// The minutes a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic minutes,

    /// The hours a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic hours,

    /// The days a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic days,

    /// The months a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic months,

    /// The weekdays a Task should be started.
    /// Can be one of `int`, `List<int>` or `String` or `null` (= match all).
    dynamic weekdays,
  }) {
    final parsedSeconds = parseConstraint(seconds)?.where((x) => x >= 0 && x <= 59).toList();
    final parsedMinutes = parseConstraint(minutes)?.where((x) => x >= 0 && x <= 59).toList();
    final parsedHours = parseConstraint(hours)?.where((x) => x >= 0 && x <= 23).toList();
    final parsedDays = parseConstraint(days)?.where((x) => x >= 1 && x <= 31).toList();
    final parsedMonths = parseConstraint(months)?.where((x) => x >= 1 && x <= 12).toList();
    final parsedWeekdays =
        parseConstraint(weekdays)?.where((x) => x >= 0 && x <= 7).map((x) => x == 0 ? 7 : x).toSet().toList();
    return Schedule._(parsedSeconds, parsedMinutes, parsedHours, parsedDays, parsedMonths, parsedWeekdays);
  }

  /// Parses the DxCrontab-formatted text and creates a schedule out of it.
  factory Schedule.parse(String cronFormat) {
    final p = cronFormat.split(_whitespacesRegExp).where((p) => p.isNotEmpty).toList();
    assert(p.length == 5 || p.length == 6);
    final parts = [
      if (p.length == 5) null,
      ...p,
    ];
    return Schedule(
      seconds: parts[0],
      minutes: parts[1],
      hours: parts[2],
      days: parts[3],
      months: parts[4],
      weekdays: parts[5],
    );
  }

  Schedule._(this.seconds, this.minutes, this.hours, this.days, this.months, this.weekdays);

  bool get _hasSeconds => seconds != null && seconds!.isNotEmpty && (seconds!.length != 1 || !seconds!.contains(0));
}

abstract class ScheduledTask {
  Schedule get schedule;
  Future cancel();
}

const int _millisecondsPerSecond = 1000;

class _DxCrontab implements DxCrontab {
  bool _closed = false;
  Timer? _timer;
  final _schedules = <_ScheduledTask>[];

  @override
  ScheduledTask schedule(Schedule schedule, Task task) {
    if (_closed) throw Exception('Closed.');
    final st = _ScheduledTask(schedule, task);
    _schedules.add(st);
    _scheduleNextTick();
    return st;
  }

  @override
  Future close() async {
    _closed = true;
    _timer?.cancel();
    _timer = null;
    for (final schedule in _schedules) {
      await schedule.cancel();
    }
  }

  void _scheduleNextTick() {
    if (_closed) return;
    if (_timer != null || _schedules.isEmpty) return;
    final now = DateTime.now();
    final isTickSeconds = _schedules.any((task) => task.schedule._hasSeconds);
    final ms = (isTickSeconds ? 1 : 60) * _millisecondsPerSecond -
        (now.millisecondsSinceEpoch % ((isTickSeconds ? 1 : 60) * _millisecondsPerSecond));
    _timer = Timer(Duration(milliseconds: ms), _tick);
  }

  void _tick() {
    _timer = null;
    final now = DateTime.now();
    for (final schedule in _schedules) {
      schedule.tick(now);
    }
    _scheduleNextTick();
  }
}

class _ScheduledTask implements ScheduledTask {
  @override
  final Schedule schedule;
  final Task _task;

  bool _closed = false;
  Future? _running;
  bool _overrun = false;

  _ScheduledTask(this.schedule, this._task);

  void tick(DateTime now) {
    if (_closed) return;
    if (!schedule.shouldRunAt(now)) return;
    _run();
  }

  void _run() {
    if (_closed) return;
    if (_running != null) {
      _overrun = true;
      return;
    }
    _running = Future.microtask(() => _task()).then((_) => null, onError: (_) => null);
    _running!.whenComplete(() {
      _running = null;
      if (_overrun) {
        _overrun = false;
        _run();
      }
    });
  }

  @override
  Future cancel() async {
    _closed = true;
    _overrun = false;
    if (_running != null) {
      await _running;
    }
  }
}

List<int>? parseConstraint(dynamic constraint) {
  if (constraint == null) return null;
  if (constraint is int) return [constraint];
  if (constraint is List<int>) return constraint;
  if (constraint is String) {
    if (constraint == '*' || constraint == '') return null;
    final parts = constraint.split(',');
    if (parts.length > 1) {
      final items = parts.map(parseConstraint).expand((list) => list!).toSet().toList();
      items.sort();
      return items;
    }

    final singleValue = int.tryParse(constraint);
    if (singleValue != null) return [singleValue];

    if (constraint.startsWith('*/')) {
      final period = int.tryParse(constraint.substring(2)) ?? -1;
      if (period > 0) {
        return List.generate(120 ~/ period, (i) => i * period);
      }
    }

    if (constraint.contains('-')) {
      final ranges = constraint.split('-');
      if (ranges.length == 2) {
        final lower = int.tryParse(ranges.first) ?? -1;
        final higher = int.tryParse(ranges.last) ?? -1;
        if (lower <= higher) {
          return List.generate(higher - lower + 1, (i) => i + lower);
        }
      }
    }
  }

  throw DxScheduleParseException('Unable to parse: $constraint');
}

/// Exception thrown when a DxCrontab data does not have an expected
/// format and cannot be parsed or processed.
class DxScheduleParseException extends FormatException {
  /// Creates a new `FormatException` with an optional error [message].
  DxScheduleParseException([String message = '']) : super(message);
}
