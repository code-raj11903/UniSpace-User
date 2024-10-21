import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/auth/login_page.dart'; // Adjust the import according to your file structure

void main() {
  testWidgets('LoginPage has a login form', (WidgetTester tester) async {
    // Build the LoginPage widget and trigger a frame
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Check that the page contains the email and password text fields
    expect(find.byType(TextFormField),
        findsNWidgets(2)); // There are 2 text fields
    expect(
        find.byType(ElevatedButton), findsOneWidget); // There is 1 login button
    expect(find.text('Login'), findsOneWidget); // The button text is 'Login'

    // Enter a valid email and password
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Check that the email and password values were input correctly
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Trigger a frame

    // Check if SnackBar appears (for invalid credentials or backend logic)
    expect(find.text('Invalid email or password'),
        findsNothing); // No error message for valid input

    // Expansion idea:
    // You could check for navigation or other side effects here after login
    // For example, you might check if Navigator.pushReplacement was called
    // by simulating a successful login.

    // await tester.pumpAndSettle();  // If there's a navigation, this will wait for it to settle
    // expect(find.byType(HomePage), findsOneWidget); // For example, check that HomePage is pushed
  });
}
