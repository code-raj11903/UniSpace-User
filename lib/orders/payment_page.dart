import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String resourceId;
  final String resourceName;
  final double resourcePrice;

  const PaymentPage({
    Key? key,
    required this.resourceId,
    required this.resourceName,
    required this.resourcePrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Resource: $resourceName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${resourcePrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              'Resource ID: $resourceId',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2), // Divider for better separation
            const SizedBox(height: 20),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Select your preferred payment method:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Example payment options
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.blue),
              title: Text('Credit/Debit Card'),
              onTap: () {
                // Implement credit/debit card payment processing here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Card payment selected')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.paypal, color: Colors.blue),
              title: Text('PayPal'),
              onTap: () {
                // Implement PayPal payment processing here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PayPal payment selected')),
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2), // Divider for better separation
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement payment processing here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment successful!')),
                );
              },
              child: const Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
