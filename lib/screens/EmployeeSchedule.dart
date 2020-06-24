import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emloyees.dart';
import '../providers/employee.dart' as emp;
import '../widgets/app_drawer.dart';
import './addEmployScreen.dart';
import './workSchedule.dart';

class EmployeeSchedule extends StatelessWidget {
  static const routeName = '/employee-schedule';

  Future<void> _refreshEmployees(BuildContext context) async {
    await Provider.of<Employees>(context, listen: false).fetchAndSetEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Employees'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEmployeeScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshEmployees(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshEmployees(context),
                    child: Consumer<Employees>(
                      builder: (ctx, employeeData, child) => ListView.builder(
                        itemCount: employeeData.items.length,
                        itemBuilder: (ctx, i) =>
                            EmployeeScheduleScreen(employeeData.items[i]),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class EmployeeScheduleScreen extends StatefulWidget {
  final emp.Employee employee;

  const EmployeeScheduleScreen(this.employee);

  @override
  _EmployeeScheduleScreenState createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> {
  var _expanded = false;

  Future<void> _getEmployees(BuildContext context) async {
    // final employee = Provider.of<Employee>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WorkSchedule(widget.employee.name, widget.employee.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.employee.name),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _getEmployees(context);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ],
          ),
          _expanded == true
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: min(widget.employee.schedule.length * 70 + 10.0, 100),
                  child: ListView(
                    children: widget.employee.schedule
                        .map(
                          (emp) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Date' + emp.date.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'start' + emp.from.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'End' + emp.till.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(
                  height: 0,
                )
        ],
      ),
    );
  }
}
