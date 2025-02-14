import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Expense.dart';
class CategoryListTile extends StatelessWidget {
  final ExpenseCategory category;
  final int amount;

  CategoryListTile({
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;



    switch (category) {
      case ExpenseCategory.Food:
        bgColor = Colors.red;
        break;
      case ExpenseCategory.Concert:
        bgColor = Colors.blue;
        break;
      case ExpenseCategory.Travel:
        bgColor = Colors.yellowAccent;
        break;
      case ExpenseCategory.Education:
        bgColor = Colors.green;
        break;
      case ExpenseCategory.Shopping:
        bgColor = Colors.purpleAccent;
        break;
    }

    return GestureDetector(
      onTap: (){},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: bgColor,
                child: Text(
                  category.toString().split('.').last[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(" ${category.toString().split('.').last}",
                  style: const TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold)),
              trailing: Text(
                " $amount THB",
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),]
          ),
        ),
      ),
    );
  }
}
