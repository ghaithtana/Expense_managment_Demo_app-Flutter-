import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:geocoder/geocoder.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewtransaction;
  final List categoryList;
  final List<CheckboxListTile> SelectedList = [];

  NewTransaction({required this.addNewtransaction, required this.categoryList});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleTransactionController = TextEditingController();
  final amountTransactionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selected_category;
  List<bool>? _isChecked;
  double lat = 0.0;
  double long = 0.0;
  bool LocationIsEnabled = false;
  String addressLine = "";

  void submitTransaction() {
    if (titleTransactionController.text.isEmpty == true ||
        amountTransactionController.text.isEmpty == true ||
        double.parse(amountTransactionController.text) <= 0 ||
        _selectedDate == null ||
        _selected_category == null) {
      return;
    } else if (lat == 0.0 && long == 0.0) {
      widget.addNewtransaction(
          titleTransactionController.text,
          double.parse(amountTransactionController.text),
          _selectedDate,
          _selected_category!,
          lat,
          long);
    } else {
      widget.addNewtransaction(
          titleTransactionController.text,
          double.parse(amountTransactionController.text),
          _selectedDate,
          _selected_category!,
          lat,
          long,
          );
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.categoryList.length, false);
  }

  Future<void> _PresentDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      builder: (context, _) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orangeAccent, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black,
              // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.orange.shade300, // button text color
              ),
            ),
          ),
          child: _!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void setSelectedCategory() {
    setState(() {
      _selected_category = _selected_category;
      Navigator.pop(context);
    });
  }

  void getCurrentLocationForUser() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPos = await Geolocator().getLastKnownPosition();
    var latitude = position.latitude;
    var longitude = position.longitude;
    print(lastPos);
    setState(() {
      lat = latitude;
      long = longitude;
    });
  }

  void _ShowCategoriesForTransactions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                var CheckBox = ListView.builder(
                  itemCount: widget.categoryList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      value: _isChecked![index],
                      title: Text(widget.categoryList[index]['name']),
                      secondary: widget.categoryList[index]['Icon'],
                      onChanged: (bool? value) {
                        setState(() {
                          for (int i = 0; i < widget.categoryList.length; i++) {
                            _isChecked![i] = false;
                            _isChecked![index] = value!;
                            _selected_category =
                                widget.categoryList[index]['name'];
                          }
                        });
                      },
                    );
                  },
                );

                return Container(
                    child: Column(children: <Widget>[
                  SizedBox(height: 350, child: Center(child: CheckBox)),
                  ElevatedButton(
                    child: Text('onay'),
                    onPressed: () {
                      setSelectedCategory();
                    },
                  )
                ]));
              }),
              behavior: HitTestBehavior.opaque);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'açıklama: '),
              controller: titleTransactionController,
              onSubmitted: (_) {
                submitTransaction();
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Tutar: "),
              controller: amountTransactionController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) {
                submitTransaction();
              },
            ),
            Container(
              height: 70,
              child: Row(children: <Widget>[
                Text(_selected_category == null
                    ? "Kategori seçilmedi"
                    : '' + _selected_category!),
                FlatButton(
                  child: Text(
                    "Kategori Seçin",
                    style: TextStyle(color: Colors.orange[300]),
                  ),
                  onPressed: () {
                    _ShowCategoriesForTransactions(context);
                  },
                ),
              ]),
            ),
            Container(
              height: 50,
              alignment: Alignment.topLeft,
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                child: Row(
                  children: <Widget>[
                    Text(lat == 0 && long == 0
                        ? "Konum: (isteğe bağlı) "
                        : 'Konum: Latitude:' +
                            lat.toString() +
                            ', Longitude:' +
                            long.toString()),
                    Center(
                      child: Switch(
                          value: LocationIsEnabled,
                          onChanged: (value) {
                            setState(() {
                              LocationIsEnabled = value;
                              if (LocationIsEnabled == true) {
                                getCurrentLocationForUser();
                              } else {
                                lat = 0;
                                long = 0;
                              }
                            });
                          },
                          activeTrackColor: Colors.orangeAccent,
                          activeColor: Colors.orange[300]),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Text(_selectedDate == null
                      ? "Tarih seçilmedi"
                      : "Seçilen Tarih: ${DateFormat.yMd().format(_selectedDate!)}"),
                  FlatButton(
                    child: Text(
                      "Tarih Seçin",
                      style: TextStyle(color: Colors.orange[300]),
                    ),
                    onPressed: () {
                      _PresentDatePicker(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orange.shade300)),
                      child: Text(
                        "İşlem Ekle",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: submitTransaction)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
