import 'package:flutter/material.dart';

import '../models/transaction.dart';

class SpendingBox extends StatelessWidget {
  final List<Transaction> _transactions;
  final int index;

  SpendingBox(this._transactions, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: FittedBox(
        child: Text(
          '\$${_transactions[index].amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}
