// models/booking.dart

class Booking {
  final String userId;
  final List<String> resourceIds; // Store resource IDs
  final String status; // e.g., Pending, Confirmed, Cancelled
  final DateTime date;
  final double totalAmount;

  Booking({
    required this.userId,
    required this.resourceIds,
    this.status = 'Pending',
    double? totalAmount,
  })  : date = DateTime.now(),
        totalAmount = totalAmount ?? 0;

  // Convert the Booking object to a map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'resource_ids': resourceIds,
      'status': status,
      'date': date.toIso8601String(),
      'total_amount': totalAmount,
    };
  }
}
