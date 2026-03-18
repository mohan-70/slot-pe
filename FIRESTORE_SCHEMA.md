// Firebase Firestore Collection Schema and Sample Data
// This file documents the structure of collections used in Bookit

// ============================================================================
// USERS Collection
// ============================================================================
// Path: /users/{userId}
// Document ID: Firebase Authentication UID
// 
// Sample Document:
{
  "email": "john@example.com",
  "displayName": "John Doe",
  "photoURL": "https://storage.googleapis.com/slotpe-booking.appspot.com/users/userid/avatar.jpg",
  "phoneNumber": "+1234567890",
  "createdAt": "2024-03-18T10:00:00Z",
  "userType": "customer", // "customer", "business_owner", "admin"
  "lastLogin": "2024-03-18T15:30:00Z",
  "isActive": true,
  "preferences": {
    "emailNotifications": true,
    "smsNotifications": false,
    "language": "en"
  }
}

// ============================================================================
// BUSINESSES Collection
// ============================================================================
// Path: /businesses/{businessId}
// 
// Sample Document:
{
  "id": "business123",
  "ownerId": "userid456",
  "name": "Elite Hair Salon",
  "description": "Premium hair styling and grooming services",
  "category": "Hair Salon",
  "phone": "+1-555-0123",
  "city": "Los Angeles",
  "address": "123 Main St, Los Angeles, CA 90001",
  "bookingSlug": "elite-hair-la", // Unique, used for public booking links
  "workingDays": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
  "openTime": "09:00",
  "closeTime": "18:00",
  "slotDurationMinutes": 30,
  "isActive": true,
  "createdAt": "2024-01-15T08:00:00Z",
  "planType": "pro", // "free", "pro", "enterprise"
  "logo": "https://storage.googleapis.com/slotpe-booking.appspot.com/businesses/business123/logo.jpg",
  "rating": 4.5,
  "reviewCount": 127,
  "totalBookings": 456,
  "aboutBusiness": "Established since 2015, we provide premium hair styling services...",
  "socialMedia": {
    "instagram": "@elitehaircorp",
    "facebook": "elitehaircorp"
  }
}

// Subcollection: /businesses/{businessId}/services
// Path: /businesses/{businessId}/services/{serviceId}
{
  "id": "service123",
  "name": "Haircut",
  "description": "Professional haircut service",
  "duration": 30, // minutes
  "price": 45.00,
  "isActive": true,
  "createdAt": "2024-01-15T08:00:00Z",
  "image": "https://...",
  "order": 1
}

// Subcollection: /businesses/{businessId}/timeSlots
// Path: /businesses/{businessId}/timeSlots/{date} (format: yyyy-MM-dd)
{
  "date": "2024-03-25",
  "slots": {
    "09:00": {
      "available": true,
      "bookedCount": 0,
      "maxCapacity": 1
    },
    "09:30": {
      "available": true,
      "bookedCount": 0,
      "maxCapacity": 1
    },
    "10:00": {
      "available": false,
      "bookedCount": 1,
      "maxCapacity": 1
    },
    "10:30": {
      "available": true,
      "bookedCount": 0,
      "maxCapacity": 1
    }
  }
}

// Subcollection: /businesses/{businessId}/reviews
// Path: /businesses/{businessId}/reviews/{reviewId}
{
  "id": "review789",
  "customerId": "userid456",
  "customerName": "Sarah Johnson",
  "customerPhoto": "https://...",
  "rating": 5,
  "comment": "Excellent service! The stylist was very professional and my hair looks amazing.",
  "createdAt": "2024-03-10T14:20:00Z",
  "helpful": 12,
  "serviceId": "service123",
  "bookingId": "booking456"
}

// ============================================================================
// BOOKINGS Collection
// ============================================================================
// Path: /bookings/{bookingId}
// 
// Sample Document:
{
  "id": "booking123",
  "businessId": "business123",
  "businessName": "Elite Hair Salon",
  "serviceId": "service123",
  "serviceName": "Haircut",
  "servicePrice": 45.00,
  "customerId": "userid456",
  "customerName": "John Doe",
  "customerPhone": "+1234567890",
  "customerEmail": "john@example.com",
  "date": "2024-03-25", // Format: yyyy-MM-dd
  "timeSlot": "10:00", // Format: HH:mm
  "duration": 30, // minutes
  "status": "confirmed", // "pending", "confirmed", "completed", "cancelled", "no-show"
  "notes": "Please note: I have sensitive scalp",
  "createdAt": "2024-03-18T11:00:00Z",
  "updatedAt": "2024-03-18T11:30:00Z",
  "cancellationReason": null,
  "cancelledAt": null,
  "completedAt": null,
  "reminderSent": true,
  "reminderSentAt": "2024-03-24T10:00:00Z"
}

// ============================================================================
// ACTIVITY LOG Collection (Optional - for auditing)
// ============================================================================
// Path: /activityLog/{logId}
// 
// Sample Document:
{
  "id": "log456",
  "userId": "userid456",
  "userType": "customer",
  "action": "booking_created",
  "bookingId": "booking123",
  "businessId": "business123",
  "details": {
    "date": "2024-03-25",
    "time": "10:00"
  },
  "ipAddress": "192.168.1.1",
  "userAgent": "Mozilla/5.0...",
  "timestamp": "2024-03-18T11:00:00Z",
  "status": "success"
}

// ============================================================================
// Firestore Index Requirements
// ============================================================================
// 
// These indexes are required for optimal query performance:
// 
// 1. Bookings by Business and Date
//    Collections: bookings
//    Fields: businessId (Ascending), date (Ascending)
// 
// 2. Bookings by Business, Date, and Time
//    Collections: bookings
//    Fields: businessId (Ascending), date (Descending), timeSlot (Ascending)
// 
// 3. Bookings by Customer
//    Collections: bookings
//    Fields: businessId (Ascending), customerId (Ascending)
// 
// 4. Bookings by Customer and Date
//    Collections: bookings
//    Fields: customerId (Ascending), createdAt (Descending)
// 
// 5. Businesses by Owner
//    Collections: businesses
//    Fields: ownerId (Ascending)
// 
// 6. Businesses by Booking Slug
//    Collections: businesses
//    Fields: bookingSlug (Ascending)
// 
// See: firestore.indexes.json for complete index configuration

// ============================================================================
// Sample Flutter Code to Initialize Collections
// ============================================================================

/*
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user profile
  static Future<void> createUserProfile(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set({
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Create business
  static Future<String> createBusiness(Map<String, dynamic> businessData) async {
    final docRef = await _firestore.collection('businesses').add({
      ...businessData,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    await docRef.update({'id': docRef.id});
    return docRef.id;
  }

  // Create booking
  static Future<String> createBooking(Map<String, dynamic> bookingData) async {
    final docRef = await _firestore.collection('bookings').add({
      ...bookingData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
    
    await docRef.update({'id': docRef.id});
    return docRef.id;
  }

  // Get user profile
  static Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Get business by slug
  static Future<QuerySnapshot> getBusinessBySlug(String slug) async {
    return await _firestore
        .collection('businesses')
        .where('bookingSlug', isEqualTo: slug)
        .limit(1)
        .get();
  }

  // Get bookings for business on date
  static Future<QuerySnapshot> getBookingsForDate(
    String businessId,
    String date,
  ) async {
    return await _firestore
        .collection('bookings')
        .where('businessId', isEqualTo: businessId)
        .where('date', isEqualTo: date)
        .orderBy('timeSlot')
        .get();
  }

  // Get upcoming bookings for customer
  static Future<QuerySnapshot> getCustomerBookings(String customerId) async {
    final today = DateTime.now();
    final dateString = today.toIso8601String().split('T')[0];
    
    return await _firestore
        .collection('bookings')
        .where('customerId', isEqualTo: customerId)
        .where('date', isGreaterThanOrEqualTo: dateString)
        .orderBy('date')
        .orderBy('timeSlot')
        .get();
  }
}
*/

// ============================================================================
// Validation Rules
// ============================================================================
// 
// Required Fields:
// - users: email, displayName, createdAt
// - businesses: ownerId, name, city, bookingSlug (unique), createdAt
// - bookings: businessId, customerId, serviceId, date, timeSlot, createdAt
// 
// Date Format: yyyy-MM-dd (e.g., 2024-03-25)
// Time Format: HH:mm 24-hour format (e.g., 14:30)
// 
// Status Values:
// - Bookings: pending, confirmed, completed, cancelled, no-show
// - Businesses: free, pro, enterprise
// 
// Field Validation:
// - email: Must be valid email format
// - phone: Must include country code
// - price: Must be >= 0
// - rating: Must be 1-5
// - slotDuration: Must be 15-480 minutes
