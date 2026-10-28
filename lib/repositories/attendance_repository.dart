import '../models/attendance_record.dart';

/// Kontrak akses data presensi AWALI.
/// UI tidak boleh tahu apakah data disimpan di memori, SQLite, atau cloud.
abstract class AttendanceRepository {
  Future<List<AttendanceRecord>> getAll();
  Future<void> add(AttendanceRecord record);
  Future<AttendanceRecord?> getById(String id);
  Future<void> clear(); // Hak penghapusan data sesuai UU PDP (PRV-03)
}
