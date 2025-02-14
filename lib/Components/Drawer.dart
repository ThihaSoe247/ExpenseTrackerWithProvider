import 'package:expense_tracker/Components/profile.dart';
import 'package:expense_tracker/Expense/expenseProvider.dart';
import 'package:expense_tracker/Screens/DetailsPage.dart';
import 'package:expense_tracker/Components/Login.dart';
import 'package:expense_tracker/Components/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _auth =AuthService();
    FirestoreService db =FirestoreService();
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(top: 75),
        child: Column(
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));
              },
              child: Container(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  leading: Icon(Icons.description),
                  title: Text("Details"),
                ),
              ),
            ),

            Spacer(),
            GestureDetector(
              onTap: () async{
                db.saveExpenses(context);
                db.saveIncomes(context);
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );

                },
              child: Container(
                color: Colors.green,
                margin: EdgeInsets.all(15),
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Save and Sign Out"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
