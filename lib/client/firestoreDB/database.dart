import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final user = FirebaseAuth.instance.currentUser!;

  // Insert Data to Firestore
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('UserCredential')
        .doc(id)
        .set(userInfoMap);
  }

  // Insert Data to Firestore
  Future addCategoryList(Map<String, dynamic> addCategoryMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('CategoryList')
        .doc(id)
        .set(addCategoryMap);
  }

  // Read All Data from FireStore
  Future<Stream<QuerySnapshot>> fetchDashboardList() async {
    return FirebaseFirestore.instance
        .collection('CategoryList')
        .where('userID', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Salary')
        .snapshots();
  }

  // Fetch the total current balance by calculating total "Income" minus total "Expense"
  Future<double> getCurrentBalance() async {
    // Fetch all documents with type "Income"
    QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
        .collection('CategoryList')
        .where('userID', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Income')
        .get();

    // Fetch all documents with type "Expense"
    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('CategoryList')
        .where('userID', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Expense')
        .get();

    // Initialize total income and expense amounts
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    // Calculate total income
    for (QueryDocumentSnapshot doc in incomeSnapshot.docs) {
      double income = doc.get('amount')?.toDouble() ?? 0.0;
      totalIncome += income;
    }

    // Calculate total expense
    for (QueryDocumentSnapshot doc in expenseSnapshot.docs) {
      double expense = doc.get('amount')?.toDouble() ?? 0.0;
      totalExpense += expense;
    }

    // Calculate and return the current balance (Income - Expense)
    return totalIncome - totalExpense;
  }

  // Fetch the total Income
  Future<double> getTotalIncome() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CategoryList')
        .where('userID', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Income')
        .get();

    // Initialize the total amount
    double income = 0.0;

    // Iterate through each document in the query snapshot
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      double subtotal = doc.get('amount')?.toDouble() ?? 0.0;
      income += subtotal;
    }

    return income;
  }

  // Fetch the total Expense
  Future<double> getTotalExpense() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('CategoryList')
        .where('userID', isEqualTo: user.uid)
        .where('type', isEqualTo: 'Expense')
        .get();

    // Initialize the total amount
    double expense = 0.0;

    // Iterate through each document in the query snapshot
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      double subtotal = doc.get('amount')?.toDouble() ?? 0.0;
      expense += subtotal;
    }

    return expense;
  }
}
