import 'package:expense_tracker/Components/database.dart';
import 'package:expense_tracker/Screens/ExpensePage.dart';
import 'package:expense_tracker/Components/service.dart';
import 'package:expense_tracker/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Expense/Expense.dart';
import '../Expense/expenseProvider.dart';
import '../Income/Income.dart';
import '../Income/incomeProvider.dart';
import 'Register.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  try {
                    await _auth.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    List<Expense> expenses = await db.fetchAllExpenses();
                    List<Income> incomes = await db.fetchAllIncomes();

                    // Ensure state is updated
                    Provider.of<ExpenseState>(context, listen: false).setExpenses(expenses);
                    Provider.of<IncomeState>(context, listen: false).setIncomes(incomes);


                    // Navigate to MyTabbedPage and replace the current screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyTabbedPage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Login failed: ${e.toString()}"),
                      ),
                    );
                  } finally {
                    emailController.clear();
                    passwordController.clear();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in both fields!'),
                    ),
                  );
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
