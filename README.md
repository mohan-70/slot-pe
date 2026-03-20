# Slotpe - Appointment Booking & Management

Slotpe is a premium, responsive Flutter application designed for small businesses to manage their appointments, services, and online presence seamlessly.

## 🚀 Features

- **Merchant Dashboard**: Real-time stats, today's schedule, and quick business actions.
- **Onboarding Journey**: Effortless setup for business details, working hours, and service categories.
- **Service Management**: Define service duration, pricing, and availability.
- **Interactive Booking Link**: Generate a unique, shareable link for customers to book slots directly.
- **Appointment Tracking**: Manage today's, upcoming, and all bookings with status updates.
- **Seamless Sharing**: Integrated WhatsApp sharing for business booking links.

## 📱 UI/UX Philosophy

- **Responsive Design**: Audited for everything from 360px wide devices upwards.
- **Premium Aesthetics**: Clean typography (Syne & DM Sans), modern color palettes, and interactive transitions.
- **Strict Validation**: Field-level validation ensures data integrity during onboarding and booking steps.

## 🛠️ Tech Stack

- **UI Framework**: Flutter (Material 3)
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Backend & Database**: [Cloud Firestore](https://firebase.google.com/docs/firestore)
- **Authentication**: [Firebase Google Sign-In](https://firebase.google.com/docs/auth/flutter/google-signin)

## 📂 Project Structure

- `lib/core`: App-wide constants, global theme, and router configuration.
- `lib/models`: Data models for businesses, services, and bookings.
- `lib/providers`: State management repositories using Riverpod.
- `lib/screens`: Feature-driven screens (Onboarding, Dashboard, Settings, etc.).
- `lib/services`: Modular Firebase interaction and authentication logic.
- `lib/widgets`: Reusable, responsive components like Cards and Navigation bars.

## 🏁 Getting Started

1. **Clone the repository.**
2. **Install dependencies**: `flutter pub get`.
3. **Firebase Setup**: Configure `firebase_options.dart` and ensure Firebase is initialized.
4. **Run the app**: `flutter run`.

## 🛡️ Audit & Quality

The application has been fully audited to ensure:
- **Zero warnings** on `flutter analyze`.
- **Modern Syntax**: Using `.withValues(alpha: ...)` for color manipulation.
- **Stability**: Safe `BuildContext` usage across async boundaries.
- **Validation**: Comprehensive error feedback and data entry integrity.
