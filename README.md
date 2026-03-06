---

title: "Food Vendor App"
author: "Priyanshu Teotia"
output: github_document
-----------------------

# 🍔 Food Vendor App

A **real-time food ordering system** built with **Flutter** and **Firebase**, enabling seamless interaction between **customers and vendors**.
The app allows customers to browse menus, add items to a cart, place orders, and track their order status, while vendors can manage menus and monitor incoming orders in real time.

This project demonstrates **mobile app development, real-time databases, state management, and push notification integration**.

---

# 📱 Application Overview

The system consists of two main interfaces:

## 👤 Customer App

Customers can:

* Browse restaurant menu
* View food items with price and image
* Add/remove items from cart
* Modify item quantities
* Place orders
* Track order status in real time

## 🧑‍🍳 Vendor App

Vendors can:

* Add new menu items
* Manage menu availability
* Receive real-time order notifications
* View incoming orders
* Update order status (Preparing → Ready → Completed)

---

# 🚀 Features

### 🍽 Menu Management

* Vendors can create and manage food items
* Toggle food availability
* Categorize menu items

### 🛒 Smart Cart System

* Add items to cart
* Increase or decrease quantity
* Remove items
* Calculate total price dynamically

### 📦 Order Management

* Customers can place orders
* Orders are stored in **Firebase Firestore**
* Vendors receive new orders instantly

### 🔔 Push Notifications

* Vendor receives notifications when a new order is placed
* Implemented using **Firebase Cloud Messaging**

### 📊 Vendor Dashboard

Displays:

* Orders overview
* Order status
* Menu management

### 🔄 Real-Time Updates

Firestore streams allow instant updates for:

* New orders
* Order status changes
* Menu availability

---

# 🏗 Architecture

The project follows the **MVVM (Model–View–ViewModel) architecture** to ensure scalability and maintainability.

```
lib/
│
├── models/
│   ├── order_model.dart
│   ├── cart_item_model.dart
│   └── menu_item_model.dart
│
├── providers/
│   ├── cart_provider.dart
│   ├── menu_provider.dart
│   └── vendor_order_provider.dart
│
├── screens/
│   ├── customer/
│   └── vendor/
│
├── services/
│   ├── firestore_service.dart
│   └── notification_service.dart
│
└── main.dart
```

---

# 🛠 Tech Stack

### Frontend

* **Flutter**
* **Dart**
* **Provider (State Management)**

### Backend

* **Firebase Firestore**
* **Firebase Cloud Messaging**

### UI Libraries

* Google Fonts
* Material UI Components

---

# 📦 Dependencies

Key packages used:

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
2. Enable:

   * **Cloud Firestore**
   * **Firebase Cloud Messaging**
3. Download `google-services.json`
4. Place it in:

```
android/app/google-services.json
```

5. Run:

```
flutter pub get
flutter run
```

---

# 📸 Screenshots

## Customer Interface

* Menu Screen
* Cart Screen
* Order Tracking

## Vendor Interface

* Dashboard
* Orders Screen
* Menu Management

*(Add screenshots inside the `/screenshots` folder and reference them here.)*

---

# 📈 Future Improvements

Possible enhancements for scaling the project:

* User authentication with Firebase Auth
* Restaurant listing and multi-vendor support
* Payment gateway integration
* Order analytics dashboard
* Customer ratings and reviews
* Location-based food discovery
* Delivery tracking system

---

# 🧪 Testing

The application has been tested for:

* Cart functionality
* Order placement
* Firestore data updates
* Vendor order notifications
* Menu availability toggling

---

# 👨‍💻 Author

**Priyanshu Teotia**

Skills:

* Flutter
* Dart
* Firebase
* Machine Learning
* Data Science

---

# 📄 License

This project is licensed under the **MIT License**.

---

# ⭐ Acknowledgements

Special thanks to:

* Flutter Community
* Firebase Documentation
* Open-source contributors

---

⭐ If you found this project useful, consider giving it a **star on GitHub**!
