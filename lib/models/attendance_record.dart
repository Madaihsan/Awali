class AttendanceRecord {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final bool isWithinOfficeRadius;
  final double faceSimilarityScore; // 0.0 - 1.0
  final String status; // 'Masuk' atau 'Pulang'

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.isWithinOfficeRadius,
    required this.faceSimilarityScore,
    required this.status,
  });
}
