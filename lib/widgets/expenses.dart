import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/expenses_list/new_balance.dart';
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
  double _currentBalance = 0.0;

  void _addMoney(double amount) {
    setState(() {
      _currentBalance += amount;
    });
    _saveAppData();
  }

  Future<void> _saveAppData() async {
    final prefs = await SharedPreferences.getInstance();

    final appData = {
      'balance': _currentBalance,
      'expenses': _registeredExpenses.map((e) => e.toJson()).toList(),
    };

    prefs.setString('appData', jsonEncode(appData));
  }

  Future<void> _loadAppData() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('appData');
    if (data == null) return;

    final decoded = jsonDecode(data);

    setState(() {
      _currentBalance = (decoded['balance'] ?? 0).toDouble();

      _registeredExpenses.clear();
      _registeredExpenses.addAll(
        (decoded['expenses'] as List).map((e) => Expense.fromJson(e)).toList(),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.45,
          child: NewExpense(onAddExpense: _addExpense),
        ),
      ),
    );
  }

  void _openAddMoneyOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (cx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(cx).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(cx).size.height * 0.25,
          child: NewBalance(onAddMoney: _addMoney),
        ),
      ),
    );
  }

  void _showNotEnoughMoneyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Not enough balance'),
        content: const Text('You cannot spend more than your current balance.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _addExpense(Expense expense) {
    if (expense.amount > _currentBalance) {
      _showNotEnoughMoneyDialog();
      return;
    }

    setState(() {
      _registeredExpenses.add(expense);
      _currentBalance -= expense.amount;
    });
    _saveAppData();
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      _currentBalance += expense.amount;
    });
    _saveAppData();
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
              _currentBalance -= expense.amount;
            });
            _saveAppData();
          },
        ),
        content: Text(
          'Expense deleted',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _bulidBalanceText() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            'Current Balance',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '\$${_currentBalance.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ],
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
                _bulidBalanceText(),
                Expanded(child: mainContant),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: _openAddMoneyOverlay,
                      icon: const Icon(Icons.account_balance_wallet),
                      label: const Text('Add Money'),
                    ),
                  ),
                ),
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
