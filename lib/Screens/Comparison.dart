import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Expense/expenseProvider.dart';
import '../Income/incomeProvider.dart';

class MoneyAnalysis extends StatefulWidget {
  const MoneyAnalysis({super.key});

  @override
  State<MoneyAnalysis> createState() => _MoneyAnalysisState();
}

class _MoneyAnalysisState extends State<MoneyAnalysis> {
  @override
  Widget build(BuildContext context) {
    int incomeAmount = context.watch<IncomeState>().totalIncomeAmount;
    int expenseAmount = context.watch<ExpenseState>().totalExpenseAmount;

    double percentage = incomeAmount > 0
        ? (expenseAmount / incomeAmount).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Money Analysis"),
        centerTitle: true,
        backgroundColor: Colors.blue[400], // AppBar background color
        elevation: 5, // Slight elevation for shadow effect
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            Text(
              "Income vs Expense",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 20),
            // Circular Progress Indicator with text in the center
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 10,
                    backgroundColor: Colors.green.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(percentage * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "of Income Spent",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // Total Income Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Income:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  Text(git init
                    git add README.md
                    git commit -m "first commit"
                    git branch -M main
                    git remote add origin https://github.com/ThihaSoe247/ExpenseTrackerWithProvider.git
                    git push -u origin main
                    "$incomeAmount THB",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Total Expense Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Expense:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                  Text(
                    "$expenseAmount THB",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
