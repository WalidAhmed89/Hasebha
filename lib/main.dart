import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';

var kColorSchem = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 20, 80, 250),
);

var kDarkColorSchem = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 20, 20, 150),
);

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Expenses(),

      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorSchem,

        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kDarkColorSchem.primaryContainer,
          foregroundColor: kDarkColorSchem.onPrimaryContainer,
        ),

        cardTheme: CardThemeData().copyWith(
          color: kDarkColorSchem.onSecondaryContainer,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorSchem.primaryContainer,
          ),
        ),

        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: kDarkColorSchem.primaryContainer,
          ),
          titleMedium: TextStyle(color: kDarkColorSchem.onPrimaryContainer),
        ),
        iconTheme: IconThemeData().copyWith(
          color: kDarkColorSchem.primaryContainer,
        ),
      ),

      theme: ThemeData().copyWith(
        colorScheme: kColorSchem,
        appBarTheme: AppBarTheme().copyWith(
          backgroundColor: kColorSchem.onPrimaryContainer,
          foregroundColor: kColorSchem.primaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color: kColorSchem.secondaryContainer,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorSchem.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: kColorSchem.onSecondaryContainer,
          ),
        ),
      ),
    ),
  );
}
