import 'package:flutter/material.dart';
import 'package:flutter_application_1/orders/order_summary_page.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.deepPurple),
                title: const Text('Credit / Debit Card'),
                onTap: () {
                  _completePayment(context); // Simulate payment and go to Order Summary
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.account_balance, color: Colors.deepPurple),
                title: const Text('Net Banking'),
                onTap: () {
                  _completePayment(context); // Simulate payment and go to Order Summary
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.mobile_friendly, color: Colors.deepPurple),
                title: const Text('UPI'),
                onTap: () {
                  _completePayment(context); // Simulate payment and go to Order Summary
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.wallet, color: Colors.deepPurple),
                title: const Text('Wallets'),
                onTap: () {
                  _completePayment(context); // Simulate payment and go to Order Summary
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completePayment(BuildContext context) {
    // Simulate payment delay and navigate to the order summary page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Payment...')),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
      );
    });
  }
}
