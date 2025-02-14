import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/Components/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Expense/Expense.dart';
import '../Income/Income.dart';
import '../Income/incomeProvider.dart';
import '../Expense/expenseProvider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService auth = AuthService();

  String? get userId => auth.getCurrentUser()?.uid;  // Get logged-in user ID

  /// Save Expenses for the Logged-in User
  Future<void> saveExpenses(BuildContext context) async {
    if (userId == null) return; // Prevent saving if user is not logged in

    var expenseState = Provider.of<ExpenseState>(context, listen: false);
    CollectionReference userExpenses = _firestore.collection('users').doc(userId).collection('expenses');

    try {
      // Delete existing expenses for this user
      QuerySnapshot snapshot = await userExpenses.get();
      for (var doc in snapshot.docs) {
        await userExpenses.doc(doc.id).delete();
      }

      print('Existing expenses deleted successfully.');

      // Save new expenses
      for (var expense in expenseState.expenseList) {
        await userExpenses.add({
          'category': expense.category.toString().split('.').last, // Convert enum to string
          'amount': expense.amount,
          'title': expense.title,
        });
      }

      print('New expenses saved successfully');
    } catch (e) {
      print('Error saving expenses: $e');
    }
  }

  /// Fetch All Expenses for the Logged-in User
  Future<List<Expense>> fetchAllExpenses() async {
    if (userId == null) return [];

    CollectionReference userExpenses = _firestore.collection('users').doc(userId).collection('expenses');
    QuerySnapshot querySnapshot = await userExpenses.get();

    return querySnapshot.docs.map(
          (doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Expense(
          title: data['title'],
          category: changeType(data['category']), // Convert string to enum
          amount: data['amount'],
        );
      },
    ).toList();
  }

  /// Convert String to Enum for ExpenseCategory
  ExpenseCategory changeType(String type) {
    try {
      return ExpenseCategory.values.firstWhere(
            (category) => category.toString().split('.').last == type,
      );
    } catch (e) {
      return ExpenseCategory.Food; // Default if no match
    }
  }

  Future<void> saveIncomes(BuildContext context) async {
    if (userId == null) return;

    var incomeState = Provider.of<IncomeState>(context, listen: false);
    CollectionReference userIncomes = _firestore.collection('users').doc(userId).collection('incomes');

    try {
      // Delete existing incomes for this user
      QuerySnapshot snapshot = await userIncomes.get();
      for (var doc in snapshot.docs) {
        await userIncomes.doc(doc.id).delete();
      }

      print('Existing incomes deleted successfully.');

      // Save new incomes
      for (var income in incomeState.incomeList) {
        await userIncomes.add({
          'amount': income.Amount,
          'source': income.source,
        });
      }

      print('New incomes saved successfully');
    } catch (e) {
      print('Error saving incomes: $e');
    }
  }

  /// Fetch All Incomes for the Logged-in User
  Future<List<Income>> fetchAllIncomes() async {
    if (userId == null) return [];

    CollectionReference userIncomes = _firestore.collection('users').doc(userId).collection('incomes');
    QuerySnapshot querySnapshot = await userIncomes.get();

    return querySnapshot.docs.map(
          (doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Income(
          Amount: data['amount'],
          source: data['source'],
        );
      },
    ).toList();
  }
}
