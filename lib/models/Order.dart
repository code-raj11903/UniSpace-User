import 'package:mongo_dart/mongo_dart.dart';

class Order {
  ObjectId id;
  ObjectId userId;
  List<ObjectId> resourceIds;
  ObjectId instituteId;
  double totalAmount;
  DateTime date;
  String status;
  String paymentStatus;

  Order({
    required this.id,
    required this.userId,
    required this.resourceIds,
    required this.instituteId,
    required this.totalAmount,
    required this.date,
    required this.status,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user_id': userId,
      'resource_ids': resourceIds,
      'institute_id': instituteId,
      'total_amount': totalAmount,
      'date': date.toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
    };
  }

  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as ObjectId,
      userId: map['user_id'] as ObjectId,
      resourceIds: List<ObjectId>.from(map['resource_ids']),
      instituteId: map['institute_id'] as ObjectId,
      totalAmount: map['total_amount'] as double,
      date: DateTime.parse(map['date']),
      status: map['status'] as String,
      paymentStatus: map['payment_status'] as String,
    );
  }
}
