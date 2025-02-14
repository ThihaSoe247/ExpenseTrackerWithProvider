import 'dart:io';
import 'package:expense_tracker/Components/Drawer.dart';
import 'package:expense_tracker/Expense/ExpenseBuilder.dart';
import 'package:expense_tracker/Components/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Expense/Expense.dart';
import '../Expense/expenseProvider.dart';
import '../Income/Income.dart';
import '../Income/IncomeBuilder.dart';
import '../Income/incomeProvider.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});
  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  TextEditingController incomeSource = TextEditingController();
  TextEditingController incomeAmount = TextEditingController();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green,Colors.blue],
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
                  child: BuildIncome(), // Income List
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildStyledButton(
              "Add Income",
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
                            "Add Income",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTextField(incomeSource, "Enter Source"),
                                const SizedBox(height: 10),
                                _buildTextField(incomeAmount, "Enter Amount",
                                    isNumber: true),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                db.fetchAllIncomes();
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
                                if (incomeAmount.text.isNotEmpty &&
                                    incomeSource.text.isNotEmpty) {
                                  final newIncome = Income(
                                    Amount: int.parse(incomeAmount.text),
                                    source: incomeSource.text,
                                  );
                                  context.read<IncomeState>().addItem(newIncome);
                                  incomeSource.clear();
                                  incomeAmount.clear();
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please fill in all fields"),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Add Income"),
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
              "Delete All Incomes",
              Colors.redAccent.shade700,
                  () {
                context.read<IncomeState>().clearAll();
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
