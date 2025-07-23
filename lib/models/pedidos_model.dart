import 'dart:convert';
import 'inventario_model.dart';

class BreakfastOrder {
  int? id;
  String customerName;
  Breakfast breakfast;
  int quantity;
  int totalPrice;
  DateTime orderDate;
  String status;

  BreakfastOrder({
    this.id,
    required this.customerName,
    required this.breakfast,
    required this.quantity,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });

  BreakfastOrder copyWith({
    int? id,
    String? customerName,
    Breakfast? breakfast,
    int? quantity,
    int? totalPrice,
    DateTime? orderDate,
    String? status,
  }) {
    return BreakfastOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      breakfast: breakfast ?? this.breakfast,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'breakfast': jsonEncode(breakfast.toMap()),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory BreakfastOrder.fromMap(Map<String, dynamic> data) {
    return BreakfastOrder(
      id: data['id'],
      customerName: data['customerName'],
      breakfast: Breakfast.fromMap(jsonDecode(data['breakfast'])),
      quantity: data['quantity'],
      totalPrice: data['totalPrice'],
      orderDate: DateTime.parse(data['orderDate']),
      status: data['status'],
    );
  }
}
