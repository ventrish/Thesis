class FireReport {
  final int id;
  final int reportedBy; // ← changed to int
  final int? fireStationId;
  final String location;
  final String landmark;
  final String description;
  final String status;
  final DateTime createdAt;

  FireReport({
    required this.id,
    required this.reportedBy,
    this.fireStationId,
    required this.location,
    required this.landmark,
    required this.description,
    required this.status,
    required this.createdAt,
  });
  

  factory FireReport.fromJson(Map<String, dynamic> json) {
    return FireReport(
      id: json['id'],
      reportedBy: json['reported_by'],
      fireStationId:
          json['fireStationId'] != null ? json['fireStationId'] as int : null,
      location: json['location'],
      landmark: json['landmark'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
