import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../mongo_service.dart';
import '../cart/cart_item.dart';
import '../orders/order_summary_page.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic>? resource;
  final String? resourceId;
  final String? resourceName;
  final double? resourcePrice;
  final String? userId;
  final Map<String, dynamic> user;
  final List<CartItem>? cartItems;
  final double? totalAmount;

  const PaymentPage({
    super.key,
    this.resource,
    this.resourceId,
    this.resourceName,
    this.resourcePrice,
    this.userId,
    required this.user,
    this.cartItems,
    this.totalAmount,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;
  String? _selectedPaymentMethod;
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  void initState() {
    super.initState();
    print('Resource details on PaymentPage load: ${widget.resource}');
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null; // Reset end date if it's before start date
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> processPayment(BuildContext context) async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and end dates.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (widget.resourceId != null &&
          widget.resourceName != null &&
          widget.resourcePrice != null) {
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

  Future<void> _processSingleResourcePayment(BuildContext context) async {
    try {
      if (widget.userId == null || widget.userId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: User ID is invalid. Please log in again.')),
        );
        return;
      }

      String resourceId =
          widget.resourceId!.replaceAll('ObjectId("', '').replaceAll('")', '');
      String bookingResult =
          await MongoDatabase.bookResource(resourceId, _startDate!, _endDate!);

      if (bookingResult == 'Resource booked successfully!') {
        String saveOrderResult = await MongoDatabase.saveOrder(
          widget.userId!,
          [resourceId],
          widget.resourcePrice!,
          _startDate!,
          _endDate!,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummaryPage(
              totalAmount: widget.resourcePrice!,
              paymentMethod: _selectedPaymentMethod!,
              user: widget.user,
              startDate: _startDate!, // Add start date
              endDate: _endDate!, // Add end date
              resource: widget.resource,
            ),
          ),
        );
      } else {
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
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const Divider(),
                    if (widget.resourceId != null &&
                        widget.resourceName != null &&
                        widget.resourcePrice != null) ...[
                      Image.network(
                        widget.resource?['image_url'] ??
                            'https://via.placeholder.com/150',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Resource: ${widget.resourceName}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description: ${widget.resource?['description'] ?? 'No description available.'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Price Per Day: ₹${widget.resourcePrice!.toStringAsFixed(2)}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Date: ${_startDate != null ? dateFormat.format(_startDate!) : 'Select'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.indigo),
                          onPressed: () => _selectDate(context, true),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Date: ${_endDate != null ? dateFormat.format(_endDate!) : 'Select'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.indigo),
                          onPressed: () => _selectDate(context, false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const Divider(),
                    RadioListTile<String>(
                      value: 'Credit/Debit Card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                      title: const Text('Credit/Debit Card'),
                      secondary:
                          const Icon(Icons.credit_card, color: Colors.indigo),
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
                      secondary:
                          const Icon(Icons.payment, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => processPayment(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 223, 223, 225),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Proceed to Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
