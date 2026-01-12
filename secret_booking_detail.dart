
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'booking_model.dart';

class SecretBookingDetail extends StatefulWidget {
  final Booking booking;
  final Function onUpdate;

  SecretBookingDetail({required this.booking, required this.onUpdate});

  @override
  _SecretBookingDetailState createState() => _SecretBookingDetailState();
}

class _SecretBookingDetailState extends State<SecretBookingDetail> {
  final ApiService api = ApiService();
  late Booking currentBooking;

  @override
  void initState() {
    super.initState();
    currentBooking = widget.booking;
  }

  // --- CALCULATION LOGIC (Din aur Paisa) ---
  int get totalDays {
    try {
      DateTime start = DateTime.parse(currentBooking.checkIn);
      DateTime end = DateTime.parse(currentBooking.checkOut);
      int days = end.difference(start).inDays;
      return days <= 0 ? 1 : days; // Kam se kam 1 din
    } catch (e) {
      return 1;
    }
  }

  double get totalAmount {
    // Price Model se aa raha hai
    return totalDays * currentBooking.price;
  }

  // --- DATE EDIT FUNCTION ---
  void _editDates() {
    TextEditingController inController = TextEditingController(text: currentBooking.checkIn);
    TextEditingController outController = TextEditingController(text: currentBooking.checkOut);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Booking Dates"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: inController, decoration: InputDecoration(labelText: "Check-in (YYYY-MM-DD)")),
            SizedBox(height: 10),
            TextField(controller: outController, decoration: InputDecoration(labelText: "Check-out (YYYY-MM-DD)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                // Ab yahan 'currentBooking.roomId' error nahi dega
                await api.updateBooking(
                    currentBooking.id,
                    inController.text,
                    outController.text,
                    currentBooking.roomId
                );

                Navigator.pop(context); // Dialog band
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dates Updated!")));

                // Refresh List & Go Back
                widget.onUpdate();
                Navigator.pop(context);

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
            child: Text("Save Changes"),
          ),
        ],
      ),
    );
  }

  // --- DELETE FUNCTION ---
  void _deleteBooking() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Cancel"),
        content: Text("Are you sure? Room will become free."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes, Cancel")
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await api.cancelBooking(currentBooking.id);
      widget.onUpdate(); // List refresh
      Navigator.pop(context); // Page band
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Canceled")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_calendar),
            tooltip: "Change Dates",
            onPressed: _editDates, // Edit Dialog open karega
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- BILL SUMMARY CARD ---
            Card(
              color: Colors.blue[50],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Total Stay", style: TextStyle(color: Colors.grey[700])),
                        Text("$totalDays Days", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    Container(height: 40, width: 1, color: Colors.grey[400]),
                    Column(
                      children: [
                        Text("Total Bill", style: TextStyle(color: Colors.grey[700])),
                        // Price calculation show karega
                        Text("₹${totalAmount.toStringAsFixed(0)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // --- USER DETAILS ---
            _row(Icons.person, "Customer Name", currentBooking.name),
            Divider(),
            _row(Icons.phone, "Phone Number", currentBooking.phone),
            Divider(),
            _row(Icons.bed, "Room Info", "${currentBooking.roomNumber} (${currentBooking.roomType})"),
            Divider(),
            _row(Icons.calendar_today, "Check In", currentBooking.checkIn),
            _row(Icons.calendar_today_outlined, "Check Out", currentBooking.checkOut),

            SizedBox(height: 40),

            // --- CANCEL BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(15)
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text("CANCEL BOOKING", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: _deleteBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Rows
  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}