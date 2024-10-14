import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/auth/login_page.dart'; // Adjust the import according to your file structure

void main() {
  testWidgets('LoginPage has a login form', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify that the LoginPage has an email field, a password field, and a login button
    expect(find.byType(TextFormField), findsNWidgets(2)); // 2 text fields
    expect(find.byType(ElevatedButton), findsOneWidget); // 1 login button
    expect(find.text('Login'),
        findsOneWidget); // Ensure the button has the correct text

    // Enter a valid email and password
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Verify that the email and password fields have the correct values
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);

    // Tap the login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Since we can't test the database functionality here, we can check if the login was attempted by checking for snackbar messages
    expect(find.text('Invalid email or password'),
        findsNothing); // This expects no error since we're simulating valid input
  });
}
