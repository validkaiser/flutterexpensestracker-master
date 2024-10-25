import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class ItemsTransaction extends StatelessWidget {
  const ItemsTransaction({
    Key? key,
    required this.trans,
    required this.deleteTransaction,
  }) : super(key: key);
  

  final Transaction trans;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: FittedBox(child: Text('Rs.${trans.amount}')),
          ),
        ),
        title: Text(
          trans.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMd().format(trans.date)),
        trailing: MediaQuery.of(context).size.width > 460
           
            ? IconButton(
                onPressed: () => deleteTransaction(trans.id),
                icon: const Icon(Icons.delete),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteTransaction(trans.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
