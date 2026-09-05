import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farmer_procurement/features/officer/screens/quality_inspection_form_screen.dart';
import 'package:smart_farmer_procurement/features/payment/screens/payment_status_screen.dart';
import 'package:smart_farmer_procurement/features/profile/screens/profile_screen.dart';
import 'package:smart_farmer_procurement/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KisanSetuApp());
  });

  testWidgets('Profile screen shows full farmer details', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Aadhaar Number'), findsOneWidget);
    expect(find.text('Bank Account Details'), findsOneWidget);
  });

  testWidgets('Inspection form requires farmer arrival before measurements', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: QualityInspectionFormScreen()));

    expect(find.text('Mark Farmer Arrived'), findsOneWidget);
  });

  testWidgets('Payment screen shows account balance and payment history', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: // Pass farmerId: 'test_farmer_123' (or appropriate dummy ID)
PaymentStatusScreen(farmerId: 'test_farmer_123')));

    expect(find.text('Available Balance'), findsOneWidget);
    expect(find.text('Past Payment History'), findsOneWidget);
  });
}