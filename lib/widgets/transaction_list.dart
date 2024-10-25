// transaction list manages the list of added items part

import 'package:flutter/material.dart';

import '../widgets/transaction_items.dart';
import '../models/transaction.dart';

class ListTransaction extends StatelessWidget {
  final List<Transaction> trans;
  final Function deleteTransaction;
   ListTransaction(this.trans, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return SizedBox(
        height: constraints.maxHeight * 0.9,
        child: trans.isEmpty
            ? LayoutBuilder(
                builder: (ctx, constraints) {
                  return Column(
                    children: <Widget>[
                      Text(
                        'No Item is added!',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Container(
                        margin: const EdgeInsets.all(30),
                        height: constraints.maxHeight * 0.56,
                        child: Image.asset(
                          'assets/images/loading.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                },
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return ItemsTransaction(trans: trans[index], deleteTransaction: deleteTransaction);
                },
                itemCount: trans.length,
              ),
      );
    });
  }
}


