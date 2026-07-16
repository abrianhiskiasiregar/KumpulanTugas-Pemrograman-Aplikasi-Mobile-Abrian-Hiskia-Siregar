import 'package:firebase_database/firebase_database.dart';
import '../models/supporter_model.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    'supporters',
  );

  // CREATE
  Future<void> addSupporter(Supporter supporter) async {
    try {
      await _dbRef.push().set(supporter.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // READ (stream realtime)
  Stream<List<Supporter>> getSupportersStream() {
    return _dbRef.onValue.map((event) {
      final List<Supporter> supportersList = [];
      final Map<dynamic, dynamic>? snapshotValue =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (snapshotValue != null) {
        snapshotValue.forEach((key, value) {
          final supporter = Supporter.fromMap(
            key.toString(),
            value as Map<dynamic, dynamic>,
          );
          supportersList.add(supporter);
        });
      }
      return supportersList;
    });
  }

  // UPDATE
  Future<void> updateSupporter(String id, Supporter supporter) async {
    try {
      await _dbRef.child(id).update(supporter.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteSupporter(String id) async {
    try {
      await _dbRef.child(id).remove();
    } catch (e) {
      rethrow;
    }
  }
}
