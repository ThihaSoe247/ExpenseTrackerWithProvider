import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/Components/database.dart';
import 'package:flutter/cupertino.dart';

import '../Expense/Expense.dart';
import 'Income.dart';

class IncomeState extends ChangeNotifier{
  List<Income> incomeList = [];
  int totalIncomeAmount = 0;
  FirestoreService db = FirestoreService();


  void fetchIncomes() async {
    try {
      incomeList = await db.fetchAllIncomes();
    } catch (e) {
      print('Error loading expenses: $e');
    }
    notifyListeners();
  }
  void setIncomes(List<Income> incomes) {
    incomeList = incomes;
    notifyListeners();
  }

  void addItem(Income income) {
    incomeList.add(income);

    notifyListeners();
  }

  int getTotalAmount(){
    totalIncomeAmount = 0;
    for(Income income in incomeList){
      totalIncomeAmount += income.Amount;
    }
    return totalIncomeAmount;
    notifyListeners();
  }

  void clearAll(){
    incomeList.clear();
    notifyListeners();
  }

  void updateItem(int index, Income updatedIncome) {
    if (index >= 0 && index < incomeList.length) {
      incomeList[index] = updatedIncome;
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < incomeList.length) {
      incomeList.removeAt(index);
      notifyListeners();
    }
  }


}

