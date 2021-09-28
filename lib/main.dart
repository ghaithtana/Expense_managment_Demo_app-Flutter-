import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Widgets/chart.dart';
import '../Widgets/new_Transaction.dart';
import 'Models/transaction.dart';
import 'Screens/googleMapScreenss.dart';
import 'Widgets/transactions_List.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
      theme: ThemeData(
          primaryColor: Colors.orange.shade300,
          fontFamily: "QuickSand",
          textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          appBarTheme: AppBarTheme(
              color: Colors.orange[300],
              textTheme: ThemeData.light().textTheme.copyWith(
                      subtitle2: TextStyle(
                    fontFamily: 'QuickSand',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: "t1",
    //     title: "New shoes",
    //     description: "nike store",
    //     amount: 100.00,
    //     date: DateTime.now()),
    // Transaction(
    //     id: "t2",
    //     title: "fruits",
    //     description: "migros",
    //     amount: 10.00,
    //     date: DateTime.now()),
    // Transaction(
    //     id: "t2",
    //     title: "burger",
    //     description: "Burger king",
    //     amount: 13.00,
    //     date: DateTime.now())
  ];

  List _categoriesList = [
    {"name": "Konut", 'Icon': Icon(Icons.house)},
    {'name': "Toplu taşıma", 'Icon': Icon(Icons.emoji_transportation)},
    {"name": 'yemek & icicek', 'Icon': Icon(Icons.fastfood)},
    {'name': 'Arclar', 'Icon': Icon(Icons.settings)},
    {'name': 'Sigorta', 'Icon': Icon(Icons.health_and_safety)},
    {'name': 'medikal & saglik', 'Icon': Icon(Icons.medical_services)},
    {"name": 'Tasarruf ve yatırım', 'Icon': Icon(Icons.account_balance_wallet)},
    {"name": 'kisisel harcama', 'Icon': Icon(Icons.person_outline_outlined)},
    {'name': "eğlence", "Icon": Icon(Icons.add_reaction)}
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
    String Tx_title,
    double Tx_amount,
    DateTime selectedDate,
    String Category,
    double lat,
    double long,
  ) {
    final newTx = Transaction(
        title: Tx_title,
        amount: Tx_amount,
        Category: Category,
        lat: lat,
        long: long,
        id: DateTime.now().toString(),
        date: selectedDate,
        description: "description");
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startProcessOfAddingNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(
              addNewtransaction: _addNewTransaction,
              categoryList: _categoriesList,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          title: Text("Gider yönetimi uygulaması"),
          actions: <Widget>[
            IconButton(
                onPressed: () => _startProcessOfAddingNewTransaction(context),
                icon: Icon(
                  Icons.add,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //Chart(_recentTransactions),
              TransactionList(
                _userTransactions,
                deleteTransaction,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _startProcessOfAddingNewTransaction(context),
        )));
  }
}
