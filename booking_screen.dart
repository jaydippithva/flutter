
import 'package:flutter/material.dart';
import 'room_model.dart';
import 'api_service.dart';
import 'BookingDetailScreen.dart'; // IMPORT ADDED HERE

class BookingScreen extends StatefulWidget {
  final Room room;
  BookingScreen({required this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  ApiService api = ApiService();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController checkIn = TextEditingController();
  TextEditingController checkOut = TextEditingController();

  // --- FUNCTION TO SHOW DATE PICKER ---
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent booking in the past
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        // Formats date to YYYY-MM-DD
        controller.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Room")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: InputDecoration(labelText: "Name")),
              SizedBox(height: 10),

              TextField(controller: phone, decoration: InputDecoration(labelText: "Phone")),
              SizedBox(height: 10),

              // --- CHECK-IN DATE FIELD ---
              TextField(
                controller: checkIn,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Check-in Date (YYYY-MM-DD)",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, checkIn),
              ),
              SizedBox(height: 10),

              // --- CHECK-OUT DATE FIELD ---
              TextField(
                controller: checkOut,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Check-out Date (YYYY-MM-DD)",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, checkOut),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  // 1. Validation Check
                  if (name.text.isEmpty || phone.text.isEmpty || checkIn.text.isEmpty || checkOut.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                    return;
                  }

                  try {
                    // 2. API Call
                    String msg = await api.bookRoom(
                      name.text,
                      phone.text,
                      widget.room.id,
                      checkIn.text,
                      checkOut.text,
                    );

                    // 3. Success Message
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));

                    // 4. Navigate to Detail Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailScreen(
                          room: widget.room,
                          customerName: name.text,
                          phone: phone.text,
                          checkIn: checkIn.text,
                          checkOut: checkOut.text,
                        ),
                      ),
                    );

                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: Text("Confirm Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}