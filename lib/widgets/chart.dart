import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool checkTxDay = recentTransactions[i].date.day == weekDay.day;
        bool checkTxMonth = recentTransactions[i].date.month == weekDay.month;
        bool checkTxYear = recentTransactions[i].date.year == weekDay.year;

        if (checkTxDay && checkTxMonth && checkTxYear) {
          totalSum += recentTransactions[i].amount;
        }
      }

      print('WeekDay:${DateFormat.E().format(weekDay)}\nAmount:$totalSum');

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            var currentDaySpending = (data['amount'] as double) / totalSpending;

            if (totalSpending == 0.0) currentDaySpending = 0.0;

            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                currentDaySpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
