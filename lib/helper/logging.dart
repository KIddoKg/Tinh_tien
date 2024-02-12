import 'dart:developer' as dev;

enum AppLogEventStatus { waiting, fail, error, success, started }

class AppLogEvent {
  String name;
  String descriptionAction;
  dynamic matchResult;
  dynamic actualResult;

  AppLogEventStatus status;

  late DateTime createdTime;

  AppLogEvent({
    required this.name,
    required this.descriptionAction,
    this.matchResult,
    this.actualResult,
    this.status = AppLogEventStatus.started,
  }) {
    createdTime = DateTime.now();
  }
}

class AppLog {
  static final AppLog _instance = AppLog._internal();

  static AppLog get instance => _instance;

  AppLog._internal();

  final List<AppLogEvent> _appLogs = [];

  void add(String name, {String description = '', StackTrace? trace}) {
    AppLogEvent log = AppLogEvent(name: name, descriptionAction: description);
    _appLogs.add(log);

    dev.log(
      '> $name\n$description\n${trace.toString()}',
    );
  }
}
