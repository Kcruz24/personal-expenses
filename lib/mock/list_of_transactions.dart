import '../models/transaction.dart';

final list_of_transactions = [
  Transaction(
    id: 't1',
    title: 'New Shoes',
    amount: 69.99,
    date: DateTime.now().subtract(Duration(days: 2)),
  ),
  Transaction(
    id: 't2',
    title: 'Weekly Groceries',
    amount: 26.53,
    date: DateTime.now().subtract(Duration(days: 1)),
  ),
  Transaction(
    id: 't3',
    title: 'AMC',
    amount: 44.28,
    date: DateTime.now(),
  ),
];
