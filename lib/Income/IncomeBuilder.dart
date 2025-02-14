import 'package:expense_tracker/Components/database.dart';
import 'package:expense_tracker/Income/incomeProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Expense/expenseProvider.dart';
import 'Income.dart';

class BuildIncome extends StatefulWidget {
  @override
  State<BuildIncome> createState() => _BuildIncomeState();
}

class _BuildIncomeState extends State<BuildIncome> {
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    TextEditingController incomeSource = TextEditingController();
    TextEditingController incomeAmount = TextEditingController();
    List<Income> incomes = context.watch<IncomeState>().incomeList;

    return ListView.builder(
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        Income income = incomes[index];
        context.read<IncomeState>().getTotalAmount();
        return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
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

            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income.source,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " + ${income.Amount} THB" ,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    incomeSource.text = income.source;
                    incomeAmount.text = income.Amount.toString();
                    showDialog(
                      context: context,
                      builder: (context) {
                              return AlertDialog(
                                  title: Text("Edit Income"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: incomeSource,
                                        decoration: InputDecoration(
                                          hintText: "Enter Income Source",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: incomeAmount,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Enter Income Amount",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (incomeSource.text.isNotEmpty &&
                                            incomeAmount.text.isNotEmpty) {
                                          final updatedIncome = Income(
                                            Amount: int.parse(incomeAmount.text),
                                            source:  incomeSource.text,
                                          );
                                          try {
                                            // Income Update
                                            context
                                                .read<IncomeState>()
                                                .updateItem(index, updatedIncome);
                                            Navigator.pop(context);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                Text(
                                                    "Error updating income: $e"),
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

                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    context
                        .read<IncomeState>()
                        .removeItem(index);
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
