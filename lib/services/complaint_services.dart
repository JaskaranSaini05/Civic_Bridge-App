import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final _db = FirebaseFirestore.instance;

  Future<void> addComplaint(Complaint complaint) async {
    await _db.collection('complaints').add(complaint.toMap());
  }
}
