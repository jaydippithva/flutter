// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'room_model.dart';
// import 'booking_model.dart';
//
// class ApiService {
//   // For Android emulator use 10.0.2.2. For real device, use your machine IP.
//   // String baseUrl = "http://localhost/hotel_api";
//   String baseUrl = "http://127.0.0.1/hotel_api";
//
//   Future<List<Room>> fetchRooms() async {
//     final response = await http.get(Uri.parse("$baseUrl/get_rooms.php"));
//     if(response.statusCode!=200) throw Exception('Failed to load rooms');
//     List jsonData = jsonDecode(response.body);
//     return jsonData.map((e) => Room.fromJson(e)).toList();
//   }
//
//   // --- NEW FUNCTION TO GET ALL BOOKINGS ---
//   Future<List<Booking>> getAllBookings() async {
//     final response = await http.get(Uri.parse("$baseUrl/get_bookings.php"));
//
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((data) => Booking.fromJson(data)).toList();
//     } else {
//       throw Exception("Failed to load bookings");
//     }
//   }
//
//
//   Future<String> bookRoom(
//       String name, String phone, String roomId, String checkIn, String checkOut) async {
//
//     // DEBUG: Console mein check karein ki data sahi hai ya nahi
//     print("Booking Data: Name: $name, Phone: $phone, ID: $roomId, In: $checkIn, Out: $checkOut");
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/book_room.php"),
//       // HEADER ADD KIYA: Server ko batane ke liye ki ye Form Data hai
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded",
//       },
//       body: {
//         "name": name,
//         "phone": phone,
//         "room_id": roomId, // Check karein ki ye '0' ya 'null' na ho
//         "check_in": checkIn,
//         "check_out": checkOut
//       },
//     );
//
//     var data = jsonDecode(response.body);
//
//     if (data['error'] != null) {
//       // Agar server abhi bhi error de, toh error message return karein
//       throw Exception(data['error']);
//     }
//
//     return data['message'].toString();
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'room_model.dart';
import 'booking_model.dart';

class ApiService {

  String baseUrl = "http://localhost/hotel_api";

  Future<List<Room>> fetchRooms() async {
    final response = await http.get(Uri.parse("$baseUrl/get_rooms.php"));

    if(response.statusCode != 200) {
      throw Exception('Failed to load rooms');
    }

    List jsonData = jsonDecode(response.body);
    return jsonData.map((e) => Room.fromJson(e)).toList();
  }


  Future<List<Booking>> getAllBookings() async {
    final uri = Uri.parse("$baseUrl/get_bookings.php");
    final response = await http.get(uri);


    print("URL: $uri");
    print("SERVER RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      try {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Booking.fromJson(data)).toList();
      } catch (e) {


        print("JSON Error: $e");
        throw Exception("Server Error: ${response.body}");
      }
    } else {
      throw Exception("Failed to load bookings. Status: ${response.statusCode}");
    }
  }

  // 1. Cancel Booking Function
  Future<void> cancelBooking(String id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cancel_booking.php"),
      body: {"id": id},
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to cancel booking");
    }
  }

  // 2. Update Booking Function
  Future<void> updateBooking(String id, String newCheckIn, String newCheckOut,String newRoomId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update_booking.php"),
      body: {
        "id": id,
        "check_in": newCheckIn,
        "check_out": newCheckOut,
        "room_id": newRoomId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update booking");
    }
  }

  Future<String> bookRoom(
      String name, String phone, String roomId, String checkIn, String checkOut) async {

    print("Booking Data: Name: $name, Phone: $phone, ID: $roomId, In: $checkIn, Out: $checkOut");

    final response = await http.post(
      Uri.parse("$baseUrl/book_room.php"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": name,
        "phone": phone,
        "room_id": roomId,
        "check_in": checkIn,
        "check_out": checkOut
      },
    );

    // DEBUG Response
    print("BOOK ROOM RESPONSE: ${response.body}");

    try {
      var data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      return data['message'].toString();
    } catch (e) {
      throw Exception("Booking Failed. Server sent: ${response.body}");
    }
  }
}