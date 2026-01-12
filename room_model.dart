class Room {
  final String id;
  final String roomNumber;
  final String type;
  final String price;
  final String status;

  Room({
    required this.id,
    required this.roomNumber,
    required this.type,
    required this.price,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"].toString(),
      roomNumber: json["room_number"] ?? '',
      type: json["type"] ?? '',
      price: json["price"].toString(),
      status: json["status"] ?? '',
    );
  }
}
