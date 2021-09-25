import 'package:flutter/material.dart';

import '../models/transaction.dart';

class SpendingBox extends StatelessWidget {
  final Transaction _transaction;

  SpendingBox(this._transaction);

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: themeContext.primaryColor,
          width: 2,
        ),
      ),
      child: FittedBox(
        child: Text(
          '\$${_transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: themeContext.primaryColorDark,
          ),
        ),
      ),
    );
  }
}
