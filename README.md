# Rustic Kitchen Flutter App

Rustic Kitchen is a Flutter + Firebase restaurant mobile app with two roles:

- Customer: browse menu, favorite items, add to cart, checkout orders, reserve tables, pre-order dishes, view booking/order history.
- Admin/Staff: dashboard metrics, manage menu items, upload food images, confirm/decline reservations, update table/floor status, CRUD tables.

## Tech Stack

- Flutter stable / Dart null safety
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Provider state management
- GoRouter navigation
- Google Fonts
- Cached Network Image
- Intl
- Image Picker

## Setup

1. Create a Firebase project.
2. Enable Authentication with Email/Password.
3. Enable Cloud Firestore and Firebase Storage.
4. Run FlutterFire CLI if you need to regenerate platform config:

```bash
flutterfire configure
```

5. Install packages:

```bash
flutter pub get
```

On Windows, enable Developer Mode if Flutter reports symlink support is required:

```powershell
start ms-settings:developers
```

6. Deploy security rules:

```bash
firebase deploy --only firestore:rules,storage
```

7. Run app:

```bash
flutter run
```

## Demo Login

The current build includes mock state so the UI can run immediately:

- Tap normal login to enter Customer mode.
- Tap `Vao che do Admin demo` to enter Admin mode.

To create a real admin account:

1. Register/login with Firebase Auth.
2. Create or update `users/{uid}` in Firestore:

```json
{
  "fullName": "Rustic Admin",
  "email": "admin@rustic.dev",
  "phone": "0909990000",
  "avatarUrl": "",
  "role": "admin",
  "membershipLevel": "Staff",
  "points": 0,
  "createdAt": "server timestamp",
  "updatedAt": "server timestamp"
}
```

## Firestore Collections

The app is designed for these collections:

- `users/{uid}`
- `categories/{categoryId}`
- `menu_items/{itemId}`
- `promotions/{promotionId}`
- `tables/{tableId}`
- `bookings/{bookingId}`
- `orders/{orderId}`
- `users/{uid}/favorites/{itemId}`
- `users/{uid}/cart/{cartItemId}`
- `reviews/{reviewId}`

## Seed Data

Mock data lives in:

- `lib/core/constants/mock_data.dart`

Firebase seed helper lives in:

- `lib/services/firebase_service.dart`

Call `FirebaseService().seedData(...)` with mock categories, menu items, and tables when you want to push demo data to Firestore.

## Main Structure

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    theme/
    utils/
    widgets/
  models/
  services/
  providers/
  repositories/
  screens/
    auth/
    customer/
    admin/
  routes/
```

## Verification

```bash
flutter analyze
```

At handoff, `flutter analyze` passes with no issues.
