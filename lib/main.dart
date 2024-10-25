
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';
import './widgets/new_transactions.dart';
import './widgets/chart.dart';

void main() {
  runApp(FlutterHopeTracker());
}

class FlutterHopeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'Expense Tracker',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // WidgetsBindingObserver is used for checking app State
  final List<Transaction> _utransactions = [];

  bool _showChart = false;
  // for switch value

  // checking app state
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    // !. => null check, if null then dont execute
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // printing app state
  }

  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  // checking app state done

  List<Transaction> get _recentTransactions {
    return _utransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String txtitle, double amount, DateTime selectedDate) {
    final newTrans = Transaction(
      title: txtitle,
      amount: amount,
      id: DateTime.now().toString(),
      date: selectedDate,
    );

    setState(() {
      _utransactions.add(newTrans);
    });
  }

  void _deleteTransaction(String transId) {
    setState(() {
      _utransactions.removeWhere((index) => (index.id == transId));
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addTransaction);
   
      },
    );
  }

  List<Widget> _isLandscape(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txList) {
    return [
      Row(
    
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          Switch.adaptive(
          
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          // if else cond., so if button on(_showChart==true) show chart only if off(_showChart==false) show list only
          ? SizedBox(
              height: ((mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7),
              child: Chart(_recentTransactions),
            )
          :
        

          txList,
    ];
  }

  List<Widget> _isPortrait(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      SizedBox(
        height: ((mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3),
        child: Chart(_recentTransactions),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScaped = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar =  AppBar(
            // NavBar for Android
            title: const Text('Expense Tracker App'),
          );

    final txList = SizedBox(
        height: ((mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7),
        child: ListTransaction(_utransactions, _deleteTransaction));

    final pageBody = SafeArea(
      // SafeArea is for IOS devices to leave spaces in top and bottom for phone bars and switches
      child: SingleChildScrollView(
        // adds scrolling feature to the full screen

        child: Column(
          /* mainAxisAlignment: MainAxisAlignment.center, */
          // to position the Cards, => vertical is mainAxis for coloumn and horizontal for Row widget

          /* crossAxisAlignment: CrossAxisAlignment.stretch, */
          //horizontal position setup

          children: <Widget>[
            if (isLandScaped)
              // checking if in landscape mode then show the button
              ..._isLandscape(mediaQuery, appBar, txList),
           

            if (!isLandScaped)
              // if not in landscape mode show small chart and show the chart too
              ..._isPortrait(mediaQuery, appBar, txList),
          ],
        ),
      ),
    );

    return Scaffold(
            appBar: appBar,
            // using it from a variable so that we can access appBar height and all from all over the code
            body: pageBody,
            floatingActionButton: Platform.isIOS
                // checks platform
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                    // this button takes color acccording to the theme accentColor
                  ),
          );
  }
}
