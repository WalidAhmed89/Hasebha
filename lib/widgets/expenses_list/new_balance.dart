import 'package:flutter/material.dart';

class NewBalance extends StatefulWidget {
  const NewBalance({super.key, required this.onAddMoney});

  final void Function(double amount) onAddMoney;

  @override
  State<StatefulWidget> createState() => _NewBalance();
}

class _NewBalance extends State<NewBalance> {
  final _balanceController = TextEditingController();

  void _submitData() {
    final enteredBalance = double.tryParse(_balanceController.text);

    if (enteredBalance == null || enteredBalance <= 0) {
      return;
    }

    widget.onAddMoney(enteredBalance);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 28, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _balanceController,
            decoration: InputDecoration(
              prefixText: '\$ ',
              label: Text(
                'Balance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 10),

          ElevatedButton(onPressed: _submitData, child: Text('Add Expense')),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
