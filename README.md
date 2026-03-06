---
title: "Food Vendor App"
author: "Priyanshu Teotia"
output: github_document
---

# 🍔 Food Vendor App

A **real-time food ordering system** built with **Flutter** and **Firebase**, enabling seamless interaction between **customers and vendors**.

The application allows customers to browse menus, add items to a cart, place orders, and track order status in real time, while vendors can manage menus and receive orders instantly.

---

# 📱 Application Overview

The system contains two interfaces:

## 👤 Customer App

Customers can:

- Browse restaurant menu
- View food items with price and image
- Add items to cart
- Modify item quantities
- Place orders
- Track order status

---

## 🧑‍🍳 Vendor App

Vendors can:

- Add menu items
- Toggle item availability
- Receive new orders in real time
- Manage incoming orders
- Update order status

---

# 🚀 Features

### 🍽 Menu Management
- Vendors can create and manage food items
- Menu availability toggle

### 🛒 Smart Cart System
- Add/remove items
- Modify quantity
- Dynamic price calculation

### 📦 Order Management
- Customers place orders
- Orders stored in Firebase Firestore
- Vendors receive orders instantly

### 🔔 Push Notifications
- Vendors get notified when a new order is placed
- Implemented using Firebase Cloud Messaging

### 🔄 Real-Time Updates
Firestore streams update:

- Orders
- Order status
- Menu availability

---

# 🏗 Project Architecture
```text
lib/
│
├── models/
│ ├── order_model.dart
│ ├── cart_item_model.dart
│ └── menu_item_model.dart
│
├── providers/
│ ├── cart_provider.dart
│ ├── menu_provider.dart
│ └── vendor_order_provider.dart
│
├── screens/
│ ├── customer/
│ └── vendor/
│
├── services/
│ ├── firestore_service.dart
│ └── notification_service.dart
│
└── main.dart
```
---

# 🛠 Tech Stack

### Frontend
- Flutter
- Dart
- Provider (State Management)

### Backend
- Firebase Firestore
- Firebase Cloud Messaging

### UI
- Material UI
- Google Fonts

---

# 📦 Dependencies

Main packages used:
```
provider
cloud_firestore
firebase_core
firebase_messaging
flutter_local_notifications
google_fonts
image_picker
```
---

# 🔥 Firebase Setup

1. Create a Firebase project  
2. Enable **Cloud Firestore**  
3. Enable **Firebase Cloud Messaging**  
4. Download `google-services.json`

Place it in:
android/app/google-services.json

Run:
flutter pub get
flutter run

---

# 📈 Future Improvements

- User authentication
- Multi-restaurant support
- Payment integration
- Delivery tracking
- Order analytics
- Food ratings and reviews

---

# 👨‍💻 Author

**Priyanshu Teotia**

Skills:

- Flutter
- Dart
- Firebase
- Machine Learning
- Data Science

---

# ⭐ Support

If you like this project, please **star the repository** on GitHub.

