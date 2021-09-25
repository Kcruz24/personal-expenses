import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'spending_box.dart';

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;
  final Function _deleteTransaction;

  TransactionItem(
    this._transaction,
    this._deleteTransaction,
  );

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: SpendingBox(_transaction),
        title: Text(
          _transaction.title,
          style: themeContext.textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(_transaction.date),
        ),
        trailing: mediaQuery.size.width > 460
            ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: themeContext.errorColor,
                onPressed: () => _deleteTransaction(_transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: themeContext.errorColor,
                onPressed: () => _deleteTransaction(_transaction.id),
              ),
      ),
    );
  }
}
