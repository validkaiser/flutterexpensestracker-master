import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTransactionHandler;

  NewTransaction(this._addNewTransactionHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _addTransaction() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedDate == null) {
      return;
    }
    String _title = _titleController.text;
    double _amount = double.parse(_amountController.text);
    DateTime _pickedDate = _selectedDate!;

    _titleController.clear();
    _amountController.clear();
    _selectedDate = null;

    widget._addNewTransactionHandler(_title, _amount, _pickedDate);
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null && date.toString().isEmpty) {
        return;
      }
      setState(() => _selectedDate = date!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Card(
        elevation: 5,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              style: const TextStyle(
                fontFamily: 'Quicksand',
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              style: const TextStyle(
                fontFamily: 'Quicksand',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 5.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0.0),
                horizontalTitleGap: 0.0,
                title: Text(
                  _selectedDate == null
                      ? 'No Date Selected!'
                      : DateFormat.yMMMd().format(_selectedDate!),
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                  ),
                ),
                leading: const Icon(Icons.date_range),
                trailing: TextButton(
                  child: Text(
                    'Choose Date',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: _showDatePicker,
                ),
              ),
            ),
            ElevatedButton(
              child: const Text(
                'Add Transaction',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _addTransaction,
            )
          ],
        ),
      ),
    );
  }
}
