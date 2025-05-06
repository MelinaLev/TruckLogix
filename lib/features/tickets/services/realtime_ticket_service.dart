import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';

class RealtimeTicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tickets';

  // Stream of all tickets for a user (real-time updates)
  Stream<List<Ticket>> getTicketsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('driverId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Ticket.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // Stream for a specific ticket (real-time updates)
  Stream<Ticket?> getTicketStream(String ticketId) {
    return _firestore
        .collection(_collection)
        .doc(ticketId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        return Ticket.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    });
  }

  // Stream of pending tickets (for managers/admin)
  Stream<List<Ticket>> getPendingTicketsStream() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'pending')
        .orderBy('date', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Ticket.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // Listen to ticket status changes
  Stream<String> getTicketStatusStream(String ticketId) {
    return _firestore
        .collection(_collection)
        .doc(ticketId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        return docSnapshot.data()?['status'] ?? 'draft';
      }
      return 'draft';
    });
  }
}