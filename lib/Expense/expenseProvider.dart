import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/Components/database.dart';
import 'package:flutter/cupertino.dart';

import 'Expense.dart';
import '../Income/Income.dart';

class ExpenseState extends ChangeNotifier{
  List<Expense> expenseList = [];
  int totalExpenseAmount = 0;
  FirestoreService db = FirestoreService();

  void fetchExpenses() async {
    try {
      expenseList = await db.fetchAllExpenses();
    } catch (e) {
      print('Error loading expenses: $e');
    }
    notifyListeners();
  }

  void addItem(Expense expense) {
    expenseList.add(expense);
    notifyListeners();
  }

  int getTotalAmount(){
    totalExpenseAmount = 0;
    for(Expense exp in expenseList){
      totalExpenseAmount += exp.amount;
    }
    return totalExpenseAmount;
    notifyListeners();
  }

  void setExpenses(List<Expense> expenses) {
    expenseList = expenses;
    notifyListeners();
  }

  Map<String, double> pie_chart = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };


  void clearAll(){
    expenseList.clear();
    notifyListeners();
  }

  void updateItem(int index, Expense updatedExpense) {
    if (index >= 0 && index < expenseList.length) {
      expenseList[index] = updatedExpense;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < expenseList.length) {
      expenseList.removeAt(index);
      notifyListeners();
    }
  }


}

