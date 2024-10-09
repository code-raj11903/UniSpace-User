import 'package:flutter/material.dart';
import '../mongo_service.dart';

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

  Future<void> processPayment(BuildContext context) async {
    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 1));

      // Log the resourceId being passed
      print("Processing payment for Resource ID: $resourceId");

      // Check if resourceId contains ObjectId and extract the hex part
      String stringResourceId;
      if (resourceId.startsWith("ObjectId(\"") && resourceId.endsWith("\")")) {
        // Extract the hex string
        stringResourceId =
            resourceId.substring(10, 34); // Extract characters 10-33
      } else {
        stringResourceId =
            resourceId; // Use as is if it’s already a proper string
      }

      // Book the resource and update its availability
      String result = await MongoDatabase.bookResource(stringResourceId);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );

      // Navigate back to the previous screen (or home screen)
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

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
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Select your preferred payment method:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Example payment options
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                // Implement credit/debit card payment processing here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card payment selected')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.paypal, color: Colors.blue),
              title: const Text('PayPal'),
              onTap: () {
                // Implement PayPal payment processing here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PayPal payment selected')),
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const Spacer(),
            ElevatedButton(
              onPressed: () => processPayment(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
