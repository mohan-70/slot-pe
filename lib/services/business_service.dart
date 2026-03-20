import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../models/business_model.dart';

class BusinessService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BusinessModel?> getBusinessByOwnerId(String ownerId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.businessCollection)
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        return null;
      }

      return BusinessModel.fromMap({
        'id': doc.docs[0].id,
        ...doc.docs[0].data(),
      });
    } catch (e) {
      return null;
    }
  }

  Future<BusinessModel?> getBusinessBySlug(String slug) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.businessCollection)
          .where('bookingSlug', isEqualTo: slug)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        return null;
      }

      return BusinessModel.fromMap({
        'id': doc.docs[0].id,
        ...doc.docs[0].data(),
      });
    } catch (e) {
      return null;
    }
  }

  Future<String> createBusiness(BusinessModel business) async {
    try {
      final docRef =
          await _firestore.collection(AppConstants.businessCollection).add(
                business.copyWith(id: '').toMap(),
              );

      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBusiness(BusinessModel business) async {
    try {
      await _firestore
          .collection(AppConstants.businessCollection)
          .doc(business.id)
          .update(business.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isSlugAvailable(String slug) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.businessCollection)
          .where('bookingSlug', isEqualTo: slug)
          .limit(1)
          .get();

      return doc.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  String generateSlug(String name, String city) {
    final combined = '$name-$city'.toLowerCase();
    // Remove special characters and replace spaces with hyphens
    final slug = combined
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
    return slug;
  }
}
