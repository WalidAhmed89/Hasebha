import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';

var kColorSchem = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 20, 20, 150));
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expenses(),
      theme: ThemeData().copyWith(colorScheme: kColorSchem,appBarTheme: AppBarTheme().copyWith(
        backgroundColor: kColorSchem.inversePrimary
      )),
    ),
  );
}
