// import 'package:fire_response_app/models/fire_reports.dart';

// // Function to parse date and sort the list
// List<FireReport> getSortedFireReports() {
//   mockFireReports.sort((a, b) {
//     DateTime dateA = DateTime.parse(_convertDate(a.date));
//     DateTime dateB = DateTime.parse(_convertDate(b.date));
//     return dateB.compareTo(dateA); // Descending (latest first)
//   });
//   return mockFireReports;
// }

// // Function to convert "March 18, 2025" to "2025-03-18"
// String _convertDate(String dateStr) {
//   final months = {
//     "January": "01",
//     "February": "02",
//     "March": "03",
//     "April": "04",
//     "May": "05",
//     "June": "06",
//     "July": "07",
//     "August": "08",
//     "September": "09",
//     "October": "10",
//     "November": "11",
//     "December": "12",
//   };
//   final parts = dateStr.split(" "); // ["March", "18,", "2025"]
//   String month = months[parts[0]]!;
//   String day = parts[1]
//       .replaceAll(",", "")
//       .padLeft(2, '0'); // Remove comma, ensure 2 digits
//   String year = parts[2];
//   return "$year-$month-$day"; // Format: YYYY-MM-DD
// }

// List<FireReport> mockFireReports = [
//   FireReport(
//     id: 1,
//     name: "JM Dela Cruz",
//     location: "Salitran I",
//     landmark: "7 Eleven",
//     description: "Residential Fire",
//     date: "2025-03-18",
//     status: "Ongoing",
//   ),
//   FireReport(
//     id: 2,
//     name: "Tina Dela Cruz",
//     location: "Imus",
//     landmark: "Mini Stop",
//     description: "Big smoke",
//     date: "2025-03-16",
//     status: "Resolved",
//   ),
//   FireReport(
//     id: 3,
//     name: "Juan Tamad",
//     location: "Salitran IV",
//     landmark: "Clubhouse",
//     description: "May gas tank sa loob ng bahay",
//     date: "2025-03-15",
//     status: "Resolved",
//   ),
//   FireReport(
//     id: 4,
//     name: "JM Dela Cruz",
//     location: "Brgy. Langkaan 1",
//     landmark: "Clubhouse",
//     description: "Residential Fire, Big smoke",
//     date: "2024-08-01",
//     status: "Resolved",
//   ),
//   FireReport(
//     id: 5,
//     name: "JM Dela Cruz",
//     location: "Lumina, Imus",
//     landmark: "Foot Bridge",
//     description: "4th floor, maraming mga papel na masusunog",
//     date: "2022-04-18",
//     status: "Resolved",
//   ),
//   FireReport(
//     id: 6,
//     name: "Emily Gomez",
//     location: "Villa Elena",
//     landmark: "Near Gate",
//     description: "Residential Fire",
//     date: "2025-02-07",
//     status: "Resolved",
//   ),
// ];
