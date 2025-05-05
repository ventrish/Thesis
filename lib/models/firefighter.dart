class Firefighter {
  final int id;
  final int userId;
  final int fireStationId;
  final int teamId;
  final String position;
  final String personalEquipment;

  Firefighter({
    required this.id,
    required this.userId,
    required this.fireStationId,
    required this.teamId,
    required this.position,
    required this.personalEquipment,
  });

  // Convert JSON to Firefighter object
  factory Firefighter.fromJson(Map<String, dynamic> json) {
    return Firefighter(
      id: json['id'],
      userId: json['userId'],
      fireStationId: json['fireStationId'],
      teamId: json['teamId'],
      position: json['position'],
      personalEquipment: json['personalEquipment'],
    );
  }

  // Convert Firefighter object to JSON for updates
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fireStationId': fireStationId,
      'teamId': teamId,
      'position': position,
      'personalEquipment': personalEquipment,
    };
  }
}
