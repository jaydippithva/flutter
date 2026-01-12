import 'package:flutter/material.dart';
import 'room_list_screen.dart';

void main() {
  runApp(HotelApp());
}

class HotelApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hotel Management",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RoomListScreen(),
    );
  }
}
