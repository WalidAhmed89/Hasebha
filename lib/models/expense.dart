import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { food, travel, trips, leisure, otherThings }

const CategoryIcons ={
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.directions_bus,
  Category.trips: Icons.airplanemode_active,
  Category.leisure: Icons.movie,
  Category.otherThings: Icons.keyboard_command_key
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

  String get formattedDate{
    return formatter.format(date);
  }
}

