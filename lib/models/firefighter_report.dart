// Model for Firefighter Report
class FirefighterReport {
  final int id;
  final int fireReportId;
  final int fireFighterId;
  final String reportType;
  final String details;
  final String attachment;
  final String createdAt;
  final String updatedAt;

  FirefighterReport({
    required this.id,
    required this.fireReportId,
    required this.fireFighterId,
    required this.reportType,
    required this.details,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FirefighterReport.fromJson(Map<String, dynamic> json) {
    return FirefighterReport(
      id: json['id'] ?? 0,
      fireReportId: json['fireReportId'] ?? 0,
      fireFighterId: json['fireFighterId'] ?? 0,
      reportType: json['reportType'] ?? '',
      details: json['details'] ?? '',
      attachment: json['attachment'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
