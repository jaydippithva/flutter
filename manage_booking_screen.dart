// import 'package:flutter/material.dart';
// import 'api_service.dart';
// import 'booking_model.dart';
//
// class ManageBookingScreen extends StatefulWidget {
//   @override
//   _ManageBookingScreenState createState() => _ManageBookingScreenState();
// }
//
// class _ManageBookingScreenState extends State<ManageBookingScreen> {
//   ApiService api = ApiService();
//
//   // Controllers for Search
//   TextEditingController searchName = TextEditingController();
//   TextEditingController searchPhone = TextEditingController();
//
//   List<Booking> allBookings = [];
//   List<Booking> foundBookings = []; // Isme wo data ayega jo match karega
//   bool isLoading = true;
//   bool hasSearched = false; // Ye check karega ki user ne search button dabaya ya nahi
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   // Saara data pehle hi load kar lete hain (background mein)
//   _loadData() async {
//     try {
//       var data = await api.getAllBookings();
//       setState(() {
//         allBookings = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error loading data: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   // --- SEARCH LOGIC ---
//   void _performSearch() {
//     String nameInput = searchName.text.toLowerCase().trim();
//     String phoneInput = searchPhone.text.trim();
//
//     if (nameInput.isEmpty || phoneInput.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Name and Phone both!")));
//       return;
//     }
//
//     setState(() {
//       hasSearched = true; // Ab hum result dikhayenge
//
//       // Filter logic: Name aur Phone dono match hone chahiye
//       foundBookings = allBookings.where((booking) {
//         return booking.name.toLowerCase() == nameInput &&
//             booking.phone == phoneInput;
//       }).toList();
//     });
//   }
//
//   // --- DELETE LOGIC ---
//   void _deleteBooking(String id) async {
//     await api.cancelBooking(id);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Canceled")));
//     _performSearch(); // List refresh karein
//     _loadData(); // Master data refresh karein
//   }
//
//   // --- EDIT LOGIC (Date Update) ---
//   void _showEditDialog(Booking booking) {
//     TextEditingController newCheckIn = TextEditingController(text: booking.checkIn);
//     TextEditingController newCheckOut = TextEditingController(text: booking.checkOut);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit Dates"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(controller: newCheckIn, decoration: InputDecoration(labelText: "Check-in (YYYY-MM-DD)")),
//               TextField(controller: newCheckOut, decoration: InputDecoration(labelText: "Check-out (YYYY-MM-DD)")),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//             ElevatedButton(
//               onPressed: () async {
//                 await api.updateBooking(booking.id, newCheckIn.text, newCheckOut.text);
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dates Updated!")));
//                 _performSearch(); // Refresh UI
//                 _loadData();
//               },
//               child: Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Manage Bookings")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // --- SEARCH SECTION ---
//             TextField(
//               controller: searchName,
//               decoration: InputDecoration(
//                 labelText: "Enter Customer Name",
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: searchPhone,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 labelText: "Enter Phone Number",
//                 prefixIcon: Icon(Icons.phone),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15), backgroundColor: Colors.blue),
//                 onPressed: _performSearch,
//                 child: Text("SEARCH BOOKING", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//             Divider(height: 30, thickness: 2),
//
//             // --- RESULT SECTION ---
//             Expanded(
//               child: isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : !hasSearched
//                   ? Center(child: Text("Enter details to search", style: TextStyle(color: Colors.grey)))
//                   : foundBookings.isEmpty
//                   ? Center(child: Text("No booking found with these details.", style: TextStyle(color: Colors.red)))
//                   : ListView.builder(
//                 itemCount: foundBookings.length,
//                 itemBuilder: (context, index) {
//                   final item = foundBookings[index];
//                   return Card(
//                     elevation: 4,
//                     margin: EdgeInsets.only(bottom: 15),
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // 1. First Name
//                           Row(
//                             children: [
//                               Icon(Icons.person, color: Colors.blue),
//                               SizedBox(width: 10),
//                               Text("Name: ${item.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//
//                           // 2. Phone
//                           Row(
//                             children: [
//                               Icon(Icons.phone, color: Colors.green),
//                               SizedBox(width: 10),
//                               Text("Phone: ${item.phone}", style: TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//
//                           // 3. Dates (Last)
//                           Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("In: ${item.checkIn}"),
//                                 Icon(Icons.arrow_forward, size: 16),
//                                 Text("Out: ${item.checkOut}"),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 15),
//
//                           // 4. Buttons (Edit & Cancel)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               OutlinedButton.icon(
//                                 icon: Icon(Icons.edit, size: 18),
//                                 label: Text("Edit"),
//                                 onPressed: () => _showEditDialog(item),
//                               ),
//                               SizedBox(width: 10),
//                               ElevatedButton.icon(
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                                 icon: Icon(Icons.delete, size: 18, color: Colors.white),
//                                 label: Text("Cancel", style: TextStyle(color: Colors.white)),
//                                 onPressed: () => _deleteBooking(item.id),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'booking_model.dart';

class ManageBookingScreen extends StatefulWidget {
  @override
  _ManageBookingScreenState createState() => _ManageBookingScreenState();
}

class _ManageBookingScreenState extends State<ManageBookingScreen> {
  ApiService api = ApiService();

  // Controllers
  TextEditingController searchName = TextEditingController();
  TextEditingController searchPhone = TextEditingController();

  List<Booking> allBookings = [];
  List<Booking> foundBookings = [];
  bool isLoading = true;
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      var data = await api.getAllBookings();
      setState(() {
        allBookings = data;
        isLoading = false;
      });
      print("Total Data Loaded: ${allBookings.length}"); // Debugging
    } catch (e) {
      print("Error loading data: $e");
      setState(() => isLoading = false);
    }
  }

  // --- FIXED SEARCH LOGIC (Smart Search) ---
  void _performSearch() {
    // Keyboard hide karne ke liye
    FocusScope.of(context).unfocus();

    String nameInput = searchName.text.trim().toLowerCase();
    String phoneInput = searchPhone.text.trim();

    if (nameInput.isEmpty && phoneInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Name OR Phone to search")));
      return;
    }

    setState(() {
      hasSearched = true;

      foundBookings = allBookings.where((bookings) {
        String dbName = bookings.name.toString().toLowerCase();
        String dbPhone = bookings.phone.toString();

        // Loose Matching (Contains) - Taaki data aasani se mile
        bool nameMatches = nameInput.isEmpty ? true : dbName.contains(nameInput);
        bool phoneMatches = phoneInput.isEmpty ? true : dbPhone.contains(phoneInput);

        return nameMatches && phoneMatches;
      }).toList();
    });
  }

  // --- DELETE LOGIC ---
  void _deleteBooking(String id) async {
    await api.cancelBooking(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Canceled")));

    // List ko refresh karein
    var newData = await api.getAllBookings();
    setState(() {
      allBookings = newData;
      // Dobara search run karein taaki list update ho jaye
      _performSearch();
    });
  }

// --- EDIT LOGIC (Date Update) ---
  void _showEditDialog(Booking booking) {
    TextEditingController newCheckIn = TextEditingController(text: booking.checkIn);
    TextEditingController newCheckOut = TextEditingController(text: booking.checkOut);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Dates"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: newCheckIn, decoration: InputDecoration(labelText: "Check-in (YYYY-MM-DD)")),
              TextField(controller: newCheckOut, decoration: InputDecoration(labelText: "Check-out (YYYY-MM-DD)")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {

                // --- YAHAN FIX KIYA HAI ---

                await api.updateBooking(
                    booking.id,
                    newCheckIn.text,
                    newCheckOut.text,
                    booking.roomId
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dates Updated!")));
                _performSearch();
                _loadData();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Bookings")),
      // FIX 1: SingleChildScrollView lagaya taaki keyboard aane par screen na kate
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Full height maintain karne ke liye
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- SEARCH SECTION ---
              TextField(
                controller: searchName,
                decoration: InputDecoration(
                  labelText: "Enter Customer Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: searchPhone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Enter Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15), backgroundColor: Colors.blue),
                  onPressed: _performSearch,
                  child: Text("SEARCH BOOKING", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              Divider(height: 30, thickness: 2),

              // --- RESULT SECTION ---
              // Expanded use kar rahe hain, isliye parent Container ki height defined honi chahiye
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : !hasSearched
                    ? Center(child: Text("Enter name or phone to search", style: TextStyle(color: Colors.grey)))
                    : foundBookings.isEmpty
                    ? Center(child: Text("No booking found.", style: TextStyle(color: Colors.red)))
                    : ListView.builder(
                  itemCount: foundBookings.length,
                  itemBuilder: (context, index) {
                    final item = foundBookings[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.blue),
                                SizedBox(width: 10),
                                Text("Name: ${item.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Phone: ${item.phone}", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.room, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Room: ${item.roomNumber}", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(height: 8),

                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("In: ${item.checkIn}"),
                                  Icon(Icons.arrow_forward, size: 16),
                                  Text("Out: ${item.checkOut}"),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: Icon(Icons.edit, size: 18),
                                  label: Text("Edit"),
                                  onPressed: () => _showEditDialog(item),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  icon: Icon(Icons.delete, size: 18, color: Colors.white),
                                  label: Text("Cancel", style: TextStyle(color: Colors.white)),
                                  onPressed: () => _deleteBooking(item.id),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}