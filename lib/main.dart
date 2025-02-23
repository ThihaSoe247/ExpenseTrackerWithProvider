import 'package:expense_tracker/Components/Drawer.dart';
import 'package:expense_tracker/Screens/ExpensePage.dart';
import 'package:expense_tracker/Screens/IncomePage.dart';
import 'package:expense_tracker/Screens/Comparison.dart';  // Ensure this import exists
import 'package:expense_tracker/Screens/DetailsPage.dart';  // Ensure this import exists
import 'package:expense_tracker/Components/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Components/database.dart';
import 'Components/service.dart';
import 'Expense/Expense.dart';
import 'Expense/expenseProvider.dart';
import 'Income/Income.dart';
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
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  AuthService auth = AuthService();


  @override
  Widget build(BuildContext context) {
    User? user = auth.getCurrentUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: user == null ?  LoginScreen() : const MyTabbedPage(),    );
  }
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({super.key});

  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();


}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FirestoreService db = FirestoreService();

  Future<void> fetchData() async {
    List<Expense> expenses = await db.fetchAllExpenses();
    List<Income> incomes = await db.fetchAllIncomes();

    // Update providers with fetched data
    if (mounted) {
      Provider.of<ExpenseState>(context, listen: false).setExpenses(expenses);
      Provider.of<IncomeState>(context, listen: false).setIncomes(incomes);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchData();
    });
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
