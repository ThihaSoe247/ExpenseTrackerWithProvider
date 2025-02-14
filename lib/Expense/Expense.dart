import '../Income/Income.dart';

class Expense {
  String title;
  int amount;
  ExpenseCategory category;
  moneyType expenseType;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    this.expenseType = moneyType.ExpenseType,

  });
}

enum ExpenseCategory { Food, Travel, Education, Shopping, Concert }


enum moneyType{
  IncomeType,
  ExpenseType,
}