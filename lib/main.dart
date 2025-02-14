import 'package:expense_tracker/Components/Drawer.dart';
import 'package:expense_tracker/Screens/ExpensePage.dart';
import 'package:expense_tracker/Screens/IncomePage.dart';
import 'package:expense_tracker/Screens/Comparison.dart';  // Ensure this import exists
import 'package:expense_tracker/Screens/DetailsPage.dart';  // Ensure this import exists
import 'package:expense_tracker/Components/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Expense/expenseProvider.dart';
import 'Income/incomeProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseState()),
        ChangeNotifierProvider(create: (context) => IncomeState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  LoginScreen(),
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({super.key});

  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.red,
          indicatorWeight: 3.0,
          tabs: const [
            Tab(icon: Icon(Icons.money_off), text: 'Expense'),
            Tab(icon: Icon(Icons.attach_money), text: 'Income'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Expense Analysis'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Money Analysis'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:  [
          ExpensePage(),  // Existing screen
          IncomePage(),  // Existing screen
          CategoryExpense(),  // Ensure you have this screen
          MoneyAnalysis(),  // Ensure you have this screen
        ],
      ),
    );
  }
}
