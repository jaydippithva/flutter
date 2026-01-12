// import 'package:flutter/material.dart';
// import 'api_service.dart';
// import 'room_model.dart';
// import 'booking_screen.dart';
//
// class RoomListScreen extends StatefulWidget {
//   @override
//   State<RoomListScreen> createState() => _RoomListScreenState();
// }
//
// class _RoomListScreenState extends State<RoomListScreen> {
//   ApiService api = ApiService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Available Rooms")),
//       body: FutureBuilder<List<Room>>(
//         future: api.fetchRooms(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//
//           var rooms = snapshot.data ?? [];
//
//           return ListView.builder(
//             itemCount: rooms.length,
//             itemBuilder: (context, index) {
//               var r = rooms[index];
//               return Card(
//                 child: ListTile(
//                   title: Text("Room ${r.roomNumber} (${r.type})"),
//                   subtitle: Text("₹${r.price} | ${r.status}"),
//                   trailing: r.status == "Available"
//                       ? ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => BookingScreen(room: r),
//                           ),
//                         );
//                       },
//                       child: Text("Book"))
//                       : Text("Booked",
//                       style: TextStyle(color: Colors.red)),
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
import 'room_model.dart';
import 'booking_screen.dart';
import 'all_bookings_screen.dart';
import 'manage_booking_screen.dart';

class RoomListScreen extends StatefulWidget {
  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Rooms"),

      ),

      // --- STEP 1: ADD DRAWER (SIDE NAV BAR) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header (Blue part)
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'Hotel Manager',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),

            // Home Button
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // All Bookings Button
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('All Bookings'),
              onTap: () {
                Navigator.pop(context);


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllBookingsScreen()),
                );

              },
            ),
            // --- 3. NEW: MANAGE BOOKING BUTTON ---
            ListTile(
              leading: Icon(Icons.edit_calendar, color: Colors.orange), // Alag color taaki dikhe
              title: Text('Manage / Cancel Booking'),
              onTap: () async{
                Navigator.pop(context); // Drawer band karein

                // Manage Screen par jayein
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageBookingScreen()),
                );

                setState(() {

                });
              },
            ),
          ],
        ),
      ),

// --- MAIN BODY (ROOM LIST) ---
      body: FutureBuilder<List<Room>>(
        future: api.fetchRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          var rooms = snapshot.data ?? [];

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              var r = rooms[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: r.status == "Available" ? Colors.green : Colors.grey,
                    child: Text(r.roomNumber.toString(), style: TextStyle(color: Colors.white)),
                  ),
                  title: Text("Room ${r.roomNumber} (${r.type})"),
                  subtitle: Text("₹${r.price} | ${r.status}"),
                  trailing: r.status == "Available"
                      ? ElevatedButton(
                      onPressed: () async{
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(room: r),
                          ),
                        );
                        setState(() {

                        });
                      },
                      child: Text("Book"))
                      : Text("Booked", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}