import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload signature to Firebase Storage
  Future<String?> uploadSignature(List<Offset> signaturePoints, String fileName) async {
    try {
      // Convert signature points to image bytes
      final bytes = await _convertSignatureToBytes(signaturePoints);

      if (bytes == null) return null;

      // Upload to Firebase Storage
      final ref = _storage.ref().child('signatures/$fileName');
      await ref.putData(bytes);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading signature: $e');
      return null;
    }
  }

  // Download signature image URL
  Future<String?> getSignatureUrl(String fileName) async {
    try {
      final ref = _storage.ref().child('signatures/$fileName');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error getting signature URL: $e');
      return null;
    }
  }

  // Upload driver profile image
  Future<String?> uploadProfileImage(Uint8List imageBytes, String userId) async {
    try {
      final ref = _storage.ref().child('profiles/$userId/profile.jpg');
      await ref.putData(imageBytes);

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // Upload document (e.g., driver's license, insurance)
  Future<String?> uploadDocument(Uint8List fileBytes, String documentType, String userId) async {
    try {
      final fileName = '${documentType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('documents/$userId/$fileName');
      await ref.putData(fileBytes);

      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading document: $e');
      return null;
    }
  }

  // Helper to convert signature points to image bytes
  Future<Uint8List?> _convertSignatureToBytes(List<Offset> points) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final paint = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.0;

      // Draw signature
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }

      final picture = recorder.endRecording();
      final image = await picture.toImage(300, 150);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error converting signature to bytes: $e');
      return null;
    }
  }
}