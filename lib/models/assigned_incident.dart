class AssignedIncident {
  final int firefighterId;
  final String location;
  final String landmark;
  final String timeReported;
  final List<String> teamName;
  final List<String> teamLeader;
  final double latitude;
  final double longitude;

  AssignedIncident({
    required this.firefighterId,
    required this.location,
    required this.landmark,
    required this.timeReported,
    required this.teamName,
    required this.teamLeader,
    required this.latitude,
    required this.longitude,
  });

  factory AssignedIncident.fromJson(Map<String, dynamic> json) {
    // Print the entire JSON object to see what data you're getting
    print('Incoming JSON: $json');

    // Check if multiple teams exist in the response and process accordingly
    List<String> teamNames = [];
    List<String> teamLeaders = [];

    // If 'teamName' is a string (single team), convert it to a list
    if (json['teamName'] is String) {
      teamNames.add(json['teamName']);
    } else if (json['teamName'] is List) {
      teamNames = List<String>.from(json['teamName']);
    }

    // If 'teamLeader' is a string (single leader), convert it to a list
    if (json['teamLeader'] is String) {
      teamLeaders.add(json['teamLeader']);
    } else if (json['teamLeader'] is List) {
      teamLeaders = List<String>.from(json['teamLeader']);
    }

    // Print the extracted team names and leaders
    print('Team Names: $teamNames');
    print('Team Leaders: $teamLeaders');
    print("Assigning Firefighter ID: ${json['firefighter_id']}");

    return AssignedIncident(
      firefighterId: json['firefighter_id'] ?? 0,
      location: json['location'] ?? 'Location unavailable',
      landmark: json['landmark'] ?? 'Landmark unavailable',
      timeReported: json['timeReported'] ?? 'Time unavailable',
      teamName: teamNames,
      teamLeader: teamLeaders,
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}
