import 'package:expense_tracker/Expense/Expense.dart';

class Income {
  int Amount;
  String source;

  moneyType incomeType;
  Income(
      {required this.Amount,
      required this.source,
        this.incomeType = moneyType.IncomeType
      });
}


