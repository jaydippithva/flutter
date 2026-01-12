class Booking {
  final String id;
  final String name;
  final String phone;
  final String roomId;
  final String roomNumber;
  final String checkIn;
  final String checkOut;
  final String roomType;
  final double price;

  Booking({
    required this.id,
    required this.name,
    required this.phone,
    required this.roomId,
    required this.roomNumber,
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
    required this.price,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      // id: json['id'].toString(),
      // name: json['name'] ?? '',
      // phone: json['phone'] ?? '',
      // roomId: json['room_id'].toString(),
      // checkIn: json['check_in'] ?? '',
      // checkOut: json['check_out'] ?? '',
      // ID ko string mein convert karte hain safety ke liye
      id: json['id'].toString(),

      // ---  Multiple names try  ---

      name: json['name'] ?? json['customer_name'] ?? json['guest_name'] ?? 'No Name Found',

      // ---  Multiple phone keys ---
      // Agar 'phone' nahi mila, toh 'mobile' try karo, fir 'phone_number' try karo
      phone: json['phone'] ?? json['customer_phone'] ?? json['contact'] ?? 'No Phone Found',

      // Room ID
      roomId: json['room_id']?.toString() ?? json['roomId']?.toString() ?? '0',
      roomType: json['type']?.toString() ?? json['roomType']??'',
      roomNumber: json['room_number']?.toString() ?? 'N/A',
      // Dates
      checkIn: json['check_in'] ?? json['checkIn'] ?? '',
      checkOut: json['check_out'] ?? json['checkOut'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}