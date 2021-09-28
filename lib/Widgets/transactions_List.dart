import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:gider_demo/Screens/googleMapScreenss.dart';
import 'package:intl/intl.dart';
import '../Models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(
    this.transactions,
    this.deleteTransaction,
  );

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  String addressLine = '';

  void getAdressBasedOnLocation(lat, long) async {
    final coordinates = new Coordinates(lat, long);
    var addreses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      addressLine =
          addreses.first.subAdminArea + ", " + addreses.first.countryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.transactions.isEmpty
        ? Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Henüz işlem eklenmemiş..",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/Images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )
        : Container(
            height: 450,
            child: ListView.builder(
              itemBuilder: (context, index) {
                widget.transactions[index].lat != 0.0 &&
                        widget.transactions[index].long != 0.0
                    ? getAdressBasedOnLocation(widget.transactions[index].lat,
                        widget.transactions[index].long)
                    : addressLine = ''; 
 
                return Card(
                  margin: EdgeInsets.all(10),
                  child: FittedBox(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            child: FittedBox(
                              child: Text(
                                "\$" +
                                    widget.transactions[index].amount
                                        .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.transactions[index].title.toString(),
                                style: Theme.of(context).textTheme.subtitle2),
                            Text(
                              DateFormat.yMMMMEEEEd()
                                  .format(widget.transactions[index].date),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            Text(
                              widget.transactions[index].Category,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            if (addressLine != '')
                              Container(
                                  width: 250,
                                  height: 15,
                                  child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Text('Konum: ' + addressLine))),
                          ],
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              widget.deleteTransaction(
                                  widget.transactions[index].id);
                            },
                          ),
                        ),
                        if (widget.transactions[index].lat != 0.0 &&
                            widget.transactions[index].long != 0.0)
                          Container(
                            child: Column(children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.location_pin),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return GoogleMapScreen(
                                      currentTransaction:
                                          widget.transactions[index],
                                      lat: widget.transactions[index].lat,
                                      long: widget.transactions[index].long,
                                    );
                                  }));
                                },
                              ),
                            ]),
                          )
                      ],
                    ),
                  ),
                );
              },
              itemCount: widget.transactions.length,
            ),
          );
  }
}
