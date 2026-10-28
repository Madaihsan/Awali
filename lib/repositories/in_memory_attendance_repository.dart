import '../models/attendance_record.dart';
import 'attendance_repository.dart';

class InMemoryAttendanceRepository implements AttendanceRepository {
  final Map<String, AttendanceRecord> _storage = {};

  @override
  Future<List<AttendanceRecord>> getAll() async {
    return _storage.values.toList();
  }

  @override
  Future<void> add(AttendanceRecord record) async {
    _storage[record.id] = record;
  }

  @override
  Future<AttendanceRecord?> getById(String id) async {
    return _storage[id];
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}
