import 'package:flutter/material.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/order_summary_page.dart';

class PaymentPage extends StatefulWidget {
  final String? resourceId; // Nullable for cart payments
  final String? resourceName;
  final double? resourcePrice;
  final String? userId;
  final List<CartItem>? cartItems; // List of cart items for cart payment
  final double? totalAmount; // Total amount for cart payment

  const PaymentPage({
    super.key,
    this.resourceId, // These will be used for single resource payments
    this.resourceName,
    this.resourcePrice,
    this.userId, // This will be used for cart payments
    this.cartItems, // This will be used if processing cart items
    this.totalAmount, // Total amount for cart payment
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  String? _selectedPaymentMethod;

  Future<void> processPayment(BuildContext context) async {
    if (_selectedPaymentMethod == null) {
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

      // For single resource payments (Buy Now)
      if (widget.resourceId != null &&
          widget.resourceName != null &&
          widget.resourcePrice != null) {
        String resourceId = widget.resourceId!
            .replaceAll('ObjectId("', '')
            .replaceAll('")', '');
        print('Attempting to book resource with ID: $resourceId');

        // Book the resource
        String bookingResult = await MongoDatabase.bookResource(resourceId);
        if (bookingResult == 'Resource booked successfully!') {
          await MongoDatabase.saveBooking(
              widget.userId!, [resourceId], widget.resourcePrice!);

          // Navigate to order summary page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSummaryPage(
                cartItems: [
                  CartItem(
                      productId: resourceId,
                      name: widget.resourceName!,
                      price: widget.resourcePrice!,
                      quantity: 1)
                ],
                totalAmount: widget.resourcePrice!,
                paymentMethod: _selectedPaymentMethod!,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking failed: $bookingResult')));
        }
      }
      // For cart payments
      else if (widget.cartItems != null &&
          widget.totalAmount != null &&
          widget.userId != null) {
        List<String> resourceIds = [];
        for (var cartItem in widget.cartItems!) {
          String result = await MongoDatabase.bookResource(cartItem.productId);
          resourceIds.add(cartItem.productId);
        }

        await MongoDatabase.saveBooking(
            widget.userId!, resourceIds, widget.totalAmount!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful for Cart Items')),
        );

        // Navigate to order summary page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummaryPage(
              cartItems: widget.cartItems!,
              totalAmount: widget.totalAmount!,
              paymentMethod: _selectedPaymentMethod!,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      setState(() {
        _isProcessing = false;
      });
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
            // Display the resource information if buying a single resource
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
            ],
            // Display the cart total if processing multiple items from cart
            if (widget.cartItems != null && widget.totalAmount != null) ...[
              const Text(
                'Cart Items:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Amount: ₹${widget.totalAmount!.toStringAsFixed(2)}',
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
            // Payment Options
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
            RadioListTile<String>(
              value: 'UPI',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              title: const Text('UPI'),
              secondary: const Icon(Icons.account_balance_wallet,
                  color: Colors.deepPurple),
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
