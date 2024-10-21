import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/order_summary_page.dart';

class PaymentPage extends StatefulWidget {
  final String? resourceId; // Nullable for single resource payments
  final String? resourceName;
  final double? resourcePrice;
  final String? userId;
  final Map<String, dynamic> user;
  final List<CartItem>? cartItems; // List of cart items for cart payment
  final double? totalAmount; // Total amount for cart payments

  const PaymentPage({
    super.key,
    this.resourceId, // Used for single resource payments
    this.resourceName,
    this.resourcePrice,
    this.userId, // Used for cart payments
    required this.user,
    this.cartItems, // Used for cart payments
    this.totalAmount, // Total amount for cart payments
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    print('User ID in PaymentPage: ${widget.userId}');
    print('Resource ID in PaymentPage: ${widget.resourceId}');
    print('Resource Price: ${widget.resourcePrice}');
  }

  // Centralized method to handle payment and booking logic
  Future<void> processPayment(BuildContext context) async {
    if (_selectedPaymentMethod == null) {
      print('Error: Payment method not selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate payment processing delay

      if (widget.resourceId != null &&
          widget.resourceName != null &&
          widget.resourcePrice != null) {
        print('Processing payment for single resource');
        await _processSingleResourcePayment(context);
      } else {
        print('Error: Resource details are incomplete.');
      }
    } catch (e) {
      print('Payment failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // Function to process payment for single resource (Buy Now)
  Future<void> _processSingleResourcePayment(BuildContext context) async {
    try {
      print('User ID in PaymentPage: ${widget.userId}');

      if (widget.userId == null || widget.userId!.isEmpty) {
        print('Error: User ID is null or empty.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: User ID is invalid. Please log in again.')),
        );
        return;
      }

      String resourceId =
          widget.resourceId!.replaceAll('ObjectId("', '').replaceAll('")', '');
      print('Attempting to book resource ID: $resourceId');

      String bookingResult = await MongoDatabase.bookResource(resourceId);

      if (bookingResult == 'Resource booked successfully!') {
        print('Resource booking successful for resource ID: $resourceId');

        // Log before saving the order
        print('Attempting to save order for userId: ${widget.userId}');
        String saveOrderResult = await MongoDatabase.saveOrder(
            widget.userId!, [resourceId], widget.resourcePrice!);
        print('Save Order Result: $saveOrderResult');

        // Navigate to Order Summary Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummaryPage(
              cartItems: [
                CartItem(
                  productId: resourceId,
                  name: widget.resourceName!,
                  price: widget.resourcePrice!,
                  quantity: 1,
                ),
              ],
              totalAmount: widget.resourcePrice!,
              user: widget.user,
              paymentMethod: _selectedPaymentMethod!,
            ),
          ),
        );
      } else {
        print('Resource booking failed: $bookingResult');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $bookingResult')),
        );
      }
    } catch (e) {
      print('Error during payment process: $e');
      throw Exception('Failed to process payment for single resource: $e');
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
            if (widget.resourceId != null &&
                widget.resourceName != null &&
                widget.resourcePrice != null) ...[
              Text(
                'Resource: ${widget.resourceName}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: ₹${widget.resourcePrice!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ] else if (widget.totalAmount != null &&
                widget.cartItems != null &&
                widget.cartItems!.isNotEmpty) ...[
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                '₹${widget.totalAmount!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
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
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            RadioListTile<String>(
              value: 'Credit/Debit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              title: const Text('Credit/Debit Card'),
              secondary: const Icon(Icons.credit_card, color: Colors.blue),
            ),
            RadioListTile<String>(
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              title: const Text('PayPal'),
              secondary: const Icon(Icons.paypal, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const Spacer(),
            _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
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
