import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.Personal;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid input',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          content: Text(
            'Make sure a valid title, amount, date and category was entered..',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                'Okay',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                label: Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),

            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                prefixText: '\$ ',
                label: Text(
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 4),

                IconButton(
                  onPressed: _presentDatePicker,
                  icon: Icon(Icons.calendar_month),
                ),

                Expanded(
                  flex: 3,
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : formatter.format(_selectedDate!),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: _submitExpenseData,
              child: Text('Add Expense'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
