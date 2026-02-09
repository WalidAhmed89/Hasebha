import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category {
  Education,
  Food,
  Transportation,
  Personal,
  Entertainment,
  Other,
}

const CategoryIcons = {
  Category.Education: Icons.school,
  Category.Food: Icons.restaurant,
  Category.Transportation: Icons.directions_bus,
  Category.Personal: Icons.person,
  Category.Entertainment: Icons.movie,
  Category.Other: Icons.more_horiz,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  // Object → Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  // Map → Object
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: Category.values.firstWhere((c) => c.name == json['category']),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
