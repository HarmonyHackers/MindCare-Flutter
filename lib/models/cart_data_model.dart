//! Chart Data Model
class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

//! Data Models
class MonthlyTransaction {
  final DateTime month;
  final double income;
  final double expenses;
  final Map<String, double> categories;
  final Map<String, double> expenseBreakdown;
  final List<Transaction> recentTransactions;

  MonthlyTransaction({
    required this.month,
    required this.income,
    required this.expenses,
    required this.categories,
    required this.expenseBreakdown,
    required this.recentTransactions,
  });
}

class Transaction {
  final DateTime date;
  final String description;
  final double amount;
  final bool isIncome;

  Transaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.isIncome,
  });
}

final List<MonthlyTransaction> transactions = [
  MonthlyTransaction(
    month: DateTime(2025, 3),
    income: 45680.00,
    expenses: 32450.75,
    categories: {
      'Donations': 32000.00,
      'Grants': 12000.00,
      'Meditation': 168000.00,
    },
    expenseBreakdown: {
      'Staff': 18000.00,
      'Programs': 8500.75,
      'Office': 2450.00,
      'Marketing': 1500.00,
      'Misc': 2000.00,
    },
    recentTransactions: [
      Transaction(
        date: DateTime(2025, 3, 25),
        description: 'Distribute food kits to 500 families',
        amount: 12000.00,
        isIncome: false,
      ),
      Transaction(
        date: DateTime(2025, 3, 22),
        description: 'Set up a skill training center',
        amount: 9000.00,
        isIncome: false,
      ),
      Transaction(
        date: DateTime(2025, 3, 18),
        description:
            'Provide micro-loans to 100 women to start small businesses',
        amount: 3500.75,
        isIncome: false,
      ),
      Transaction(
        date: DateTime(2025, 3, 15),
        description: 'Build 5 temporary shelters for homeless families',
        amount: 8000.00,
        isIncome: false,
      ),
      Transaction(
        date: DateTime(2025, 3, 10),
        description: 'Donetion Ratan Tata Foundation',
        amount: 85000.00,
        isIncome: true,
      ),
    ],
  ),
  MonthlyTransaction(
    month: DateTime(2025, 2),
    income: 42500.00,
    expenses: 30200.50,
    categories: {
      'Donations': 30500.00,
      'Grants': 10000.00,
      'Merchandise': 2000.00,
    },
    expenseBreakdown: {
      'Staff': 18000.00,
      'Programs': 7200.50,
      'Office': 2000.00,
      'Marketing': 1000.00,
      'Misc': 2000.00,
    },
    recentTransactions: [
      Transaction(
        date: DateTime(2025, 2, 28),
        description: 'Staff Payroll',
        amount: 9000.00,
        isIncome: false,
      ),
      Transaction(
        date: DateTime(2025, 2, 20),
        description: 'Individual Donations',
        amount: 8500.00,
        isIncome: true,
      ),
    ],
  ),
  MonthlyTransaction(
    month: DateTime(2025, 1),
    income: 40200.00,
    expenses: 29800.25,
    categories: {
      'Donations': 28200.00,
      'Grants': 10000.00,
      'Merchandise': 2000.00,
    },
    expenseBreakdown: {
      'Staff': 18000.00,
      'Programs': 6800.25,
      'Office': 2000.00,
      'Marketing': 1000.00,
      'Misc': 2000.00,
    },
    recentTransactions: [
      Transaction(
        date: DateTime(2025, 1, 15),
        description: 'Monthly Grant - XYZ Foundation',
        amount: 8000.00,
        isIncome: true,
      ),
    ],
  ),
];
