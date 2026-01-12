import 'package:flutter/material.dart';
import 'room_model.dart';

class BookingDetailScreen extends StatelessWidget {
  final Room room;
  final String customerName;
  final String phone;
  final String checkIn;
  final String checkOut;

  BookingDetailScreen({
    required this.room,
    required this.customerName,
    required this.phone,
    required this.checkIn,
    required this.checkOut,
  });

  // Helper to calculate total days
  int get days {
    DateTime start = DateTime.parse(checkIn);
    DateTime end = DateTime.parse(checkOut);
    return end.difference(start).inDays;
  }

  // Helper to calculate total price
  double get totalPrice {
    int totalDays = days == 0 ? 1 : days;
    double pricePerNight = double.tryParse(room.price.toString()) ?? 0.0;
    // FIX 1: Added .toDouble() to prevent type mismatch error
    return pricePerNight * totalDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmation"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green[100],
                child: Icon(Icons.check, color: Colors.green, size: 50),
              ),
            ),
            SizedBox(height: 20),
            Center(child: Text("Booking Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            SizedBox(height: 30),

            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow(Icons.person, "Name", customerName),
                    Divider(),
                    _buildRow(Icons.phone, "Phone", phone),
                    Divider(),
                    // FIX 2: Removed 'widget.' (Use 'room' directly in StatelessWidget)
                    _buildRow(Icons.hotel, "Room No", room.roomNumber.toString()),
                    Divider(),
                    _buildRow(Icons.calendar_today, "Check-In", checkIn),
                    Divider(),
                    _buildRow(Icons.calendar_today_outlined, "Check-Out", checkOut),
                    Divider(),
                    _buildRow(Icons.attach_money, "Total Price", "\₹${totalPrice.toStringAsFixed(2)}"),

                  ],
                ),
              ),
            ),
            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}