import 'dart:io';

import 'package:expense_tracker/Expense/ExpenseListTile.dart';
import 'package:expense_tracker/Components/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../Expense/Expense.dart';
import '../Expense/expenseProvider.dart';

class CategoryExpense extends StatefulWidget {
  const CategoryExpense({super.key});

  @override
  State<CategoryExpense> createState() => _CategoryExpenseState();
}

class _CategoryExpenseState extends State<CategoryExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background color

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ExpenseState>(
              builder: (context, expenseState, child) {
                int totalExpense = expenseState.getTotalAmount();
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade300, Colors.pink.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Total Expense: $totalExpense THB",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<ExpenseState>(
              builder: (BuildContext context, expenseState, child) {
                List<Expense> expenses = expenseState.expenseList;
                Map<String, double> categoryTotals = {};
                for (var expense in expenses) {
                  String categoryName =
                      expense.category.toString().split('.').last;
                  categoryTotals[categoryName] =
                      (categoryTotals[categoryName] ?? 0) +
                          expense.amount.toDouble();
                }

                return Container(
                  height: 350,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: categoryTotals.isNotEmpty
                      ? PieChart(
                    dataMap: categoryTotals,
                    chartType: ChartType.disc,
                    baseChartColor: Colors.grey[300]!,
                    chartRadius:
                    MediaQuery.of(context).size.width / 2.5,
                    colorList: const [
                      Colors.blue,
                      Colors.red,
                      Colors.green,
                      Colors.orange
                    ],
                    legendOptions: const LegendOptions(showLegends: true),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false,
                    ),
                  )
                      : const Center(child: Text("No data available")),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Spending Breakdown",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ExpenseState>(
                builder: (BuildContext context, expenseState, child) {
                  List<Expense> expenses = expenseState.expenseList;
                  Map<ExpenseCategory, int> categoryTotals = {};

                  for (var expense in expenses) {
                    if (categoryTotals.containsKey(expense.category)) {
                      categoryTotals[expense.category] =
                          categoryTotals[expense.category]! + expense.amount;
                    } else {
                      categoryTotals[expense.category] = expense.amount;
                    }
                  }

                  var sortedCategoryTotals = categoryTotals.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));

                  return ListView.builder(
                    itemCount: sortedCategoryTotals.length,
                    itemBuilder: (context, index) {
                      ExpenseCategory category =
                          sortedCategoryTotals[index].key;
                      int totalExpense = sortedCategoryTotals[index].value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CategoryListTile(
                            category: category, amount: totalExpense),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
