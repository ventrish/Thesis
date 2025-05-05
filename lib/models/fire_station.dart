class FireStation {
  final int id;
  final String firestationName;
  final String firestationLocation;
  final String firestationContactNumber;
  final String latitude;
  final String longitude;

  FireStation({
    required this.id,
    required this.firestationName,
    required this.firestationLocation,
    required this.firestationContactNumber,
    required this.latitude,
    required this.longitude,
  });

  factory FireStation.fromJson(Map<String, dynamic> json) {
    return FireStation(
      id: json['id'],
      firestationName: json['firestationName'],
      firestationLocation: json['firestationLocation'],
      firestationContactNumber: json['firestationContactNumber'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firestationName': firestationName,
      'firestationLocation': firestationLocation,
      'firestationContactNumber': firestationContactNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
