import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/Home/home_page.dart'; // Adjust the import path to your DashboardScreen file

// Create a testable subclass of DashboardScreen to access its state
class TestableDashboardScreen extends DashboardScreen {
  DashboardScreenState getState() {
    return DashboardScreenState();
  }
}

void main() {
  group('DashboardScreen Unit Tests', () {
    test('Calculate balances correctly for mixed transactions', () {
      // Arrange: Create a mock list of transactions
      final transactions = [
        {'amount': 100.0}, // Income
        {'amount': -50.0}, // Expense
        {'amount': 200.0}, // Income
        {'amount': -25.0}, // Expense
      ];

      // Create an instance of the testable widget and access its state
      final dashboardState = TestableDashboardScreen().getState();

      // Act: Call the method
      final balances = dashboardState.calculateBalances(transactions);

      // Assert: Verify the results
      expect(balances['totalBalance'], 225.0); // 100 + (-50) + 200 + (-25) = 225
      expect(balances['income'], 300.0); // 100 + 200 = 300
      expect(balances['expenses'], 75.0); // 50 + 25 = 75
    });

    test('Calculate balances for empty transactions list', () {
      // Arrange: Empty transactions list
      final transactions = <Map<String, dynamic>>[];

      // Create an instance of the testable widget and access its state
      final dashboardState = TestableDashboardScreen().getState();

      // Act: Call the method
      final balances = dashboardState.calculateBalances(transactions);

      // Assert: Verify the results
      expect(balances['totalBalance'], 0.0);
      expect(balances['income'], 0.0);
      expect(balances['expenses'], 0.0);
    });

    test('Calculate balances for provided sample data', () {
      // Arrange: Use the provided sample data, ensuring amounts are doubles
      final transactions = [
        {'amount': 453.0, 'title': 'food'},
        {'amount': 453.0, 'title': 'food'},
      ];

      // Create an instance of the testable widget and access its state
      final dashboardState = TestableDashboardScreen().getState();

      // Act: Call the method
      final balances = dashboardState.calculateBalances(transactions);

      // Assert: Verify the results
      expect(balances['totalBalance'], 906.0); // 453.0 + 453.0 = 906.0
      expect(balances['income'], 906.0); // 453.0 + 453.0 = 906.0
      expect(balances['expenses'], 0.0); // No negative amounts
    });
  });
}