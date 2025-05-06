import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tickets';

  // Add/Update a ticket
  Future<void> saveTicket(Ticket ticket) async {
    try {
      await _firestore.collection(_collection).doc(ticket.id).set(ticket.toJson());
    } catch (e) {
      print('Error saving ticket: $e');
      throw e;
    }
  }

  // Get all tickets for current user
  Future<List<Ticket>> getTickets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Ticket.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting tickets: $e');
      return [];
    }
  }

  // Get a specific ticket by ID
  Future<Ticket?> getTicketById(String ticketId) async {
    try {
      final docSnapshot = await _firestore.collection(_collection).doc(ticketId).get();

      if (docSnapshot.exists) {
        return Ticket.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
      }
      return null;
    } catch (e) {
      print('Error getting ticket: $e');
      return null;
    }
  }

  // Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    try {
      await _firestore.collection(_collection).doc(ticketId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating ticket status: $e');
      throw e;
    }
  }

  // Delete a ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await _firestore.collection(_collection).doc(ticketId).delete();
    } catch (e) {
      print('Error deleting ticket: $e');
      throw e;
    }
  }

  // Get tickets by date range (for timecards)
  Future<List<Ticket>> getTicketsByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      return querySnapshot.docs
          .map((doc) => Ticket.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting tickets by date range: $e');
      return [];
    }
  }
}