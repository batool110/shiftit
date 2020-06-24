import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/scheduleItem.dart';
import '../providers/emloyees.dart';

class WorkSchedule extends StatefulWidget {
  static const routeName = '/work-schedule';

  WorkSchedule(String name, String id);

  @override
  _WorkScheduleState createState() => _WorkScheduleState();
}

class _WorkScheduleState extends State<WorkSchedule> {
  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");

    final _form = GlobalKey<FormState>();

    final dateController = TextEditingController();

    final fromController = TextEditingController();

    final tillController = TextEditingController();

    var _addSchedule = 
      EmployeeSchedule(id: '', date: null, from: null, till: null);

    //     final employeeId =
    //     ModalRoute.of(context).settings.arguments as String; // is the id!
    // final loadedEmployee = Provider.of<Employees>(
    //   context,
    //   listen: false,
    // ).findById(employeeId);

    Future<void> _saveForm() async {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }
      _form.currentState.save();
      print(_addSchedule.toString());
      try {
        // final scheduleItem = await Provider.of<Employees>(context, listen: false).addSchedule(_addSchedule.date, _addSchedule.from, _addSchedule.till);
        // print(scheduleItem.toString());

        print('Work Date: '+ _addSchedule.date.toString());
        await Provider.of<Employees>(context, listen: false)
            .addEmployeeSchedule([_addSchedule], 'Batool', 'sij292jd8z');
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // print(tillController.text);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Batool'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (ctx, i) => Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: <Widget>[
                DateTimeField(
                  format: format,
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onSaved: (value) {
                    _addSchedule =
                      EmployeeSchedule(
                        id: _addSchedule.id,
                        date: value.toString(),
                        from: _addSchedule.from,
                        till: _addSchedule.till,
                      );
                  },
                ),
                DateTimeField(
                  format: format,
                  controller: fromController,
                  decoration: InputDecoration(labelText: 'starting work time'),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                  onSaved: (value) {
                     _addSchedule =
                      EmployeeSchedule(
                        id: _addSchedule.id,
                        date: _addSchedule.date,
                        from: value.toString(),
                        till: _addSchedule.till,
                      );
                  },
                ),
                DateTimeField(
                  format: format,
                  controller: tillController,
                  decoration: InputDecoration(labelText: 'Ending work time'),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                  onSaved: (value) {
                     _addSchedule =
                      EmployeeSchedule(
                        id: _addSchedule.id,
                        date: _addSchedule.date,
                        from: _addSchedule.from,
                        till: value.toString(),
                      );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
