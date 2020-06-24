import 'package:flutter/foundation.dart';

class EmployeeSchedule {
  final String id;
  final String date;
  final String from;
  final String till;

  EmployeeSchedule({
    @required this.id,
    @required this.date,
    @required this.from,
    @required this.till,
  });
}

class ScheduleItem with ChangeNotifier {
  Map<String, EmployeeSchedule> _items = {};

  Map<String, EmployeeSchedule> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String id,
    String date,
    String from,
    String till,
  ) {
    _items.putIfAbsent(
      id,
      () => EmployeeSchedule(
        id: DateTime.now().toString(),
        date: date,
        from: from,
        till: till,
      ),
    );
    notifyListeners();
  }
}
