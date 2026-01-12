// import 'package:flutter/material.dart';
// import 'api_service.dart';
// import 'booking_model.dart';
//
// class AllBookingsScreen extends StatefulWidget {
//   @override
//   _AllBookingsScreenState createState() => _AllBookingsScreenState();
// }
//
// class _AllBookingsScreenState extends State<AllBookingsScreen> {
//   ApiService api = ApiService();
//   late Future<List<Booking>> futureBookings;
//
//   @override
//   void initState() {
//     super.initState();
//     futureBookings = api.getAllBookings(); // Load data when screen opens
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("All Bookings")),
//       body: FutureBuilder<List<Booking>>(
//         future: futureBookings,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No bookings found."));
//           }
//
//           // DATA MIL GAYA, LIST DIKHAO
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               Booking booking = snapshot.data![index];
//               return Card(
//                 margin: EdgeInsets.all(10),
//                 elevation: 3,
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     child: Text(booking.roomId), // Show Room ID in circle
//                     backgroundColor: Colors.blueAccent,
//                     foregroundColor: Colors.white,
//                   ),
//                   title: Text(booking.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Phone: ${booking.phone}"),
//                       SizedBox(height: 5),
//                       Row(
//                         children: [
//                           Icon(Icons.login, size: 16, color: Colors.green),
//                           Text(" ${booking.checkIn}  "),
//                           Icon(Icons.logout, size: 16, color: Colors.red),
//                           Text(" ${booking.checkOut}"),
//                         ],
//                       ),
//                     ],
//                   ),
//                   isThreeLine: true,
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'booking_model.dart';
import 'secret_booking_detail.dart';

class AllBookingsScreen extends StatefulWidget {
  @override
  _AllBookingsScreenState createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  ApiService api = ApiService();
  late Future<List<Booking>> futureBookings;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      futureBookings = api.getAllBookings();
    });
  }

  // --- PASSWORD DIALOG LOGIC ---
  void _checkPasswordAndOpen(Booking booking) {
    TextEditingController passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Security Check"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter Admin Password to view details & cancel."),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                // PASSWORD CHECK
                if (passController.text == "sahil23") {
                  Navigator.pop(context); // Dialog band

                  // Secret Page par jao
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecretBookingDetail(
                        booking: booking,
                        onUpdate: _refreshList,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong Password!")));
                }
              },
              child: Text("Unlock"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Bookings List")),
      body: FutureBuilder<List<Booking>>(
        future: futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No bookings found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Booking booking = snapshot.data![index];

              // --- SIRF NAME DIKHEGA ---
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Icon(Icons.lock, color: Colors.grey),
                  title: Text(
                    booking.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Tap to unlock details"), // User ko hint
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),


                  onTap: () => _checkPasswordAndOpen(booking),
                ),
              );
            },
          );
        },
      ),
    );
  }
}