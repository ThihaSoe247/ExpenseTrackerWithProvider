import 'dart:io';
import 'package:expense_tracker/Components/Drawer.dart';
import 'package:expense_tracker/Expense/ExpenseBuilder.dart';
import 'package:expense_tracker/Components/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Expense/Expense.dart';
import '../Expense/expenseProvider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() => _ExpendPageState();
}

class _ExpendPageState extends State<ExpensePage> {
  TextEditingController expenseTitle = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.values.first;
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.purpleAccent.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Flexible(
              child: Card(
                elevation: 8,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildExpense(), // Expense List
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildStyledButton(
              "Add Expense",
              Colors.greenAccent.shade700,
                  () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            "Add Expense",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTextField(expenseTitle, "Enter Expense"),
                                const SizedBox(height: 10),
                                _buildTextField(expenseAmount, "Enter Amount",
                                    isNumber: true),
                                const SizedBox(height: 10),
                                DropdownButton<ExpenseCategory>(
                                  value: _selectedCategory,
                                  dropdownColor: Colors.white,
                                  items: ExpenseCategory.values.map(
                                        (ExpenseCategory category) {
                                      return DropdownMenuItem<ExpenseCategory>(
                                        value: category,
                                        child: Text(
                                          category.toString().split('.').last,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (newCategory) {
                                    setState(() {
                                      _selectedCategory = newCategory!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                db.fetchAllExpenses();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (expenseTitle.text.isNotEmpty &&
                                    expenseAmount.text.isNotEmpty) {
                                  final newExpense = Expense(
                                    title: expenseTitle.text,
                                    category: _selectedCategory,
                                    amount: int.parse(expenseAmount.text),
                                  );
                                  context.read<ExpenseState>().addItem(newExpense);
                                  expenseTitle.clear();
                                  expenseAmount.clear();
                                  _selectedCategory =
                                      ExpenseCategory.values.first;
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please fill in all fields"),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Add Expense"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            _buildStyledButton(
              "Delete All Expenses",
              Colors.redAccent.shade700,
                  () {
                context.read<ExpenseState>().clearAll();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
