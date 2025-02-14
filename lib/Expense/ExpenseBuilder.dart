import 'package:expense_tracker/Components/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Income/incomeProvider.dart';
import 'Expense.dart';
import 'expenseProvider.dart';

class BuildExpense extends StatefulWidget {
  @override
  State<BuildExpense> createState() => _BuildExpenseState();
}


class _BuildExpenseState extends State<BuildExpense> {

  FirestoreService db =  FirestoreService();


  @override
  Widget build(BuildContext context) {
    TextEditingController expenseTitle = TextEditingController();
    TextEditingController expenseAmount = TextEditingController();
    ExpenseCategory _selectedCategory = ExpenseCategory.values.first;
    List<Expense> expenses = context.watch<ExpenseState>().expenseList;

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        Expense expense = expenses[index];
        IconData expenseIcon;
        switch (expense.category) {
          case ExpenseCategory.Food:
            expenseIcon = Icons.fastfood;
            break;
          case ExpenseCategory.Travel:
            expenseIcon = Icons.flight;
            break;
          case ExpenseCategory.Education:
            expenseIcon = Icons.school;
            break;
          case ExpenseCategory.Concert:
            expenseIcon = Icons.mic;
            break;
          default:
            expenseIcon = Icons.money;
        }

        return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 5,
                blurRadius: 7,
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(expenseIcon),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " - ${expense.amount} THB",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            subtitle: Text(expense.category.toString().split('.').last),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    expenseTitle.text = expense.title;
                    expenseAmount.text = expense.amount.toString();
                    _selectedCategory = expense.category;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context,setState) {
                            return AlertDialog(
                                title: Text("Edit Expense"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: expenseTitle,
                                      decoration: InputDecoration(
                                        hintText: "Enter Expense Title",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextField(
                                      controller: expenseAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Enter Amount",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    DropdownButton<ExpenseCategory>(
                                      value: _selectedCategory,
                                      items: ExpenseCategory.values.map((
                                          category) {
                                        return DropdownMenuItem(
                                          value: category,
                                          child: Text(
                                              category
                                                  .toString()
                                                  .split('.')
                                                  .last),
                                        );
                                      }).toList(),
                                      onChanged: (newCategory) {
                                        if (newCategory != null) {
                                          setState(() {
                                            _selectedCategory = newCategory;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (expenseTitle.text.isNotEmpty &&
                                          expenseAmount.text.isNotEmpty) {
                                        final updatedExpense = Expense(
                                          title: expenseTitle.text,
                                          category: _selectedCategory,
                                          amount: int.parse(expenseAmount.text),
                                        );
                                        try {
                                          // await db.updateExpense(
                                          //     expense.documentId!,
                                          //     updatedExpense);
                                          context
                                              .read<ExpenseState>()
                                              .updateItem(index,
                                              updatedExpense);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                              Text(
                                                  "Error updating expense: $e"),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Please fill in all fields")),
                                        );
                                      }
                                    },
                                    child: Text("Save Changes"),
                                  )
                                ]);
                          });
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    if (index != null) {
                      context
                          .read<ExpenseState>()
                          .removeItem(index);
                    } else {
                      print("Error: Expense document ID is null.");
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
