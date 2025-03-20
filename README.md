# MyFinance

MyFinance is a personal finance management mobile application built with **Flutter** and **Firebase**. It empowers users to monitor their income, expenses, and overall financial health through intuitive features like transaction tracking, category management, and analytics. With real-time data syncing and local notifications, MyFinance aims to simplify personal finance management.

⚠️ **Note**: This project is a work-in-progress. Some features are incomplete or under active development.

## ✨ Features

### 🔑 Authentication
- **Signup**: Register a new account with email and password.
- **Signin**: Log in using existing credentials.
- **Signout**: Securely log out from the app.

### 💸 Transaction Management
- **Add Transaction**: Record new income or expense entries.
- **Edit Transaction**: Update details of existing transactions.
- **Delete Transaction**: Remove unwanted transaction records.

### 🗂️ Category Management
- **Add Category**: Create custom categories (e.g., Food, Rent).
- **Edit Category**: Modify category names or details.
- **Delete Category**: Remove unused categories.

### 📊 Dashboard
- **Total Balance**: View current balance (Income - Expenses).
- **Income & Expense Summary**: Quick overview of totals.
- **Recent Transactions**: See the latest transaction history.

### 📈 Analytics Page
- **Bar Graph**: Visualize spending per category.
- **Filtering Options**:
  - By Type: All, Income, Expense.
  - By Time: Week, Month, Year.

### 🔔 Notifications
- **Local Notifications**: Receive reminders or alerts for financial activities.

### 🚀 Onboarding Screen
- **Introduction Flow**: Guides new users through key features on first launch.

### 👤 Account Page
- **User Details**: Displays user info (e.g., name, email).
- **Profile Management**: Basic settings (under development).

## 🛠️ Technologies Used

- **Flutter**: Cross-platform framework for UI and logic.
- **Firebase**:
  - Firebase Authentication: Manages signup, signin, and signout.
  - Firestore: Stores transactions, categories, and user data.
- **SharedPreferences**: Local storage for preferences and session data.
- **Local Notifications**: Flutter Local Notifications for in-app alerts.
- **State Management**: Provider (for managing app state).

## 🌐 Project Status

This project is actively being developed. Planned or partially implemented features include:
- Advanced analytics (e.g., trends over time).
- Enhanced account page (e.g., profile editing).
- Scheduled notifications for recurring transactions.
- UI refinements and bug fixes.

🌟 **Contributions and feedback are warmly welcomed!**

## 📋 Prerequisites

To run the project, ensure you have:

- **Flutter SDK** (version 3.x.x or latest stable).
- **Dart** (included with Flutter).
- **Android Studio** or **VS Code** with Flutter/Dart plugins.
- **Firebase Account** with a configured project.
- **Node.js** (for Firebase CLI).
- A **physical device** or **emulator/simulator**.

## 🛠️ Setup Instructions

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/Temsegn/MyFinance_Management.git
cd MyFinance_Management

# MyFinance Project Setup Guide

## 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/Temsegn/MyFinance_Management.git
cd MyFinance_Management
2. Install Dependencies
After cloning the repository, install the required dependencies. Run the following command to fetch the packages:

bash
Copy
flutter pub get
This will install all the necessary dependencies listed in the pubspec.yaml file for the project.

3. Set Up Firebase
3.1 Create a Firebase Project
Go to the Firebase Console and create a new project (e.g., "MyFinance").

3.2 Add an App to Firebase
For Android:

Use the package name com.example.myfinance.
Download google-services.json from Firebase and place it in the android/app/ directory.
For iOS:

Use your app's bundle ID.
Download GoogleService-Info.plist and place it in the ios/Runner/ directory.
3.3 Enable Firebase Authentication
Go to Authentication > Sign-in method and enable Email/Password.
3.4 Set Up Firestore
Create a database in Test Mode.
Define collections for users, transactions, and categories.
3.5 Install Firebase CLI
If you don’t have Firebase CLI installed, run the following command to install it globally:

bash
Copy
npm install -g firebase-tools
firebase login
3.6 Configure Firebase for Flutter
Run the following command to configure FlutterFire:

bash
Copy
flutterfire configure
This will generate the necessary firebase_options.dart file in your project.

4. Configure Local Notifications
Add flutter_local_notifications to your pubspec.yaml file.
For Android: Update the AndroidManifest.xml file with the necessary notification permissions.
For iOS: Request notification permissions in the AppDelegate.swift.
5. Run the App
Once all dependencies are installed and Firebase is configured, you can run the app:

5.1 Run the App
To run the app, connect a device or launch an emulator/simulator:

bash
Copy
flutter run
5.2 For a Release Build
To run the app in release mode, use the following command:

bash
Copy
flutter run --release
5.3 Run on a Specific Device
To run the app on a specific device, use:

``bash

flutter run -d <device-id>
6. Troubleshooting
Firebase Issues:
Ensure that google-services.json (for Android) and GoogleService-Info.plist (for iOS) are correctly placed in the android/app/ and ios/Runner/ directories.
Build Errors:
If you face build issues, try cleaning the project and reinstalling dependencies:
bash
Copy
flutter clean
flutter pub get
Permissions:
Ensure that notification permissions are granted for the app on both Android and iOS.
Notes
Firebase Configuration: Make sure your Firebase credentials are properly configured, and you have enabled the necessary services such as Firebase Authentication and Firestore.
Notifications: Ensure that you have set up the required permissions for both Android and iOS to send local notifications.
Build Failures: If you encounter issues after making changes or installing dependencies, always try running flutter clean and flutter pub get to resolve issues related to project dependencies.
vbnet
Copy

### Breakdown of the Changes:

