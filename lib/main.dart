import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'mock/list_of_transactions.dart';

void main() {
  // Set Portrait mode only
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = list_of_transactions;

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    stdout.write('New state: ');
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTransaction = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeContext = Theme.of(context);

    double chartHeight = 0.65;
    double txListHeight = 0.7;

    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final PreferredSizeWidget appBar = _buildAppBar(themeContext, context);

    if (isPortrait) chartHeight = 0.3;

    final calculateChartHeight = (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        chartHeight;

    final calculateTransactionListHeight = (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        txListHeight;

    final displayTxListWidget = Container(
      height: calculateTransactionListHeight,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final displayChartWidget = Container(
      height: calculateChartHeight,
      child: Chart(_recentTransactions),
    );

    List<Widget> _buildPortraitContent() {
      return [displayChartWidget, displayTxListWidget];
    }

    List<Widget> _buildLandscapeContent() {
      return [
        _buildChartSwitch(themeContext),
        _showChart ? displayChartWidget : displayTxListWidget,
      ];
    }

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isPortrait) ..._buildPortraitContent(),
            if (isLandscape) ..._buildLandscapeContent(),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container() // Don't render anything.
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }

  ///////////////////// Builder Methods ////////////////////////////
  Row _buildChartSwitch(ThemeData themeContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show Chart',
          style: themeContext.textTheme.headline6,
        ),
        Switch.adaptive(
          activeColor: themeContext.accentColor,
          value: _showChart,
          onChanged: (value) {
            setState(() {
              _showChart = value;
            });
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(themeContext, context) {
    return Platform.isIOS
        ? _buildCupertinoAppBar(themeContext, context)
        : _buildAndroidAppBar(context);
  }

  AppBar _buildAndroidAppBar(BuildContext context) {
    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  CupertinoNavigationBar _buildCupertinoAppBar(
    ThemeData themeContext,
    BuildContext context,
  ) {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              CupertinoIcons.add,
              color: themeContext.textTheme.button.color,
            ),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    );
  }
}
