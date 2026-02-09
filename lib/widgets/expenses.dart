import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() => _Expenses();
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final expensesJson = _registeredExpenses.map((e) => e.toJson()).toList();

    prefs.setString('expenses', jsonEncode(expensesJson));
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('expenses');
    if (data == null) return;

    final decoded = jsonDecode(data) as List;

    setState(() {
      _registeredExpenses.clear();
      _registeredExpenses.addAll(
        decoded.map((e) => Expense.fromJson(e)).toList(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.75,
          child: NewExpense(onAddExpense: _addExpense),
        ),
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
    _saveExpenses();
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    _saveExpenses();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.black,
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
            _saveExpenses();
          },
        ),
        content: Text(
          'Expense deleted',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContant = Center(
      child: Text(
        'There no expenses. Start adding some!',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContant = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add)),
        ],
        title: Text('Hasebha'),
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContant),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContant),
              ],
            ),
    );
  }
}
