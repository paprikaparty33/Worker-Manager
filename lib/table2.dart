import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';
import 'worker.dart';
//import 'dbmanager.dart';
import 'table1.dart';

class TableTwo extends StatefulWidget {
  const TableTwo({super.key});

  @override
  State<TableTwo> createState() => _TableTwoState();
}

class _TableTwoState extends State<TableTwo> {
  final _formKey = GlobalKey<FormState>();
  late List<Worker> selectedWorkers;
  List<Worker> _workers = [];
  @override
  void initState() {
    super.initState();
    bool selected = false;
    super.initState();
    selectedWorkers = [];
    getWorkers();
  }

  getWorkers() {
    WorkersDatabase.instance.readAllWorkers().then((workers) {
      setState(() {
        _workers = workers;
      });
    });
  }

  onSelectedRow(bool selected, Worker worker) async {
    setState(() {
      if (selected) {
        selectedWorkers.add(worker);
      } else {
        selectedWorkers.remove(worker);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SizedBox dataBody() {
      return SizedBox(
        height: height * 0.63,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 50,
              //sortAscending: sort,
              sortColumnIndex: 0,
              columns: const [
                DataColumn(
                    label: Text('Name'), tooltip: 'This is the last name'),
                DataColumn(label: Text('Salary')),
              ],
              rows: _workers
                  .map((worker) => DataRow(
                          selected: selectedWorkers.contains(worker),
                          cells: [
                            DataCell(
                              Text(worker.name),
                            ),
                            DataCell(
                              Text(
                                  '${worker.a * 30 + worker.b * 20 + worker.c * 10}'),
                            ),
                          ]))
                  .toList(),
            ),
          ),
        ),
      );
    }

    buttonCreate(String text) {
      return TextButton(
        style: ButtonStyle(
          enableFeedback: false,
          backgroundColor: MaterialStateProperty.all(Colors.lime),
        ),
        onPressed: () {
          if (text == 'Calculate salary') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    child: AlertDialog(
                      scrollable: true,
                      title: Text('Transferred to the accounting department'),
                      content: const Padding(padding: EdgeInsets.all(8.0)),
                      actions: [
                        TextButton(
                            child: Text("Submit",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  );
                });
          }
        },
        child: Text(
          '$text',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker`s Salary Manager',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lime,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dataBody(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonCreate('Calculate salary'),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
