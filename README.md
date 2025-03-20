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
flutter pub get
flutter run
