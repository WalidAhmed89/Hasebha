# 💰 Hasebha

Hasebha is a production-ready Flutter expense tracking application designed to help users manage personal finances efficiently.  
It provides real-time balance validation, categorized expense tracking, responsive UI behavior, and persistent local storage.

The application emphasizes clean architecture, controlled state management, and reliable offline data persistence.

---

## ✨ Core Features

- Balance management with validation logic  
- Add expenses with structured inputs:
  - Title  
  - Amount  
  - Date selection  
  - Category  
- Automatic balance deduction on expense creation  
- Overspending protection (business rule enforcement)  
- Expense visualization via dynamic chart  
- Undo deletion with SnackBar feedback  
- Responsive layout (mobile & larger screens)  
- Light / Dark theme compatibility  
- Persistent local storage  

---

## 🏛 Application Architecture

Hasebha follows a structured and maintainable architecture:

- StatefulWidget for controlled UI state  
- setState() for deterministic UI updates  
- Model-based data structure (Expense model)  
- JSON serialization (`toJson()` / `fromJson()`)  
- Local persistence using SharedPreferences  

All financial data (balance and expenses) is stored locally as encoded JSON.

---

## 🛠 Technology Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter |
| Language | Dart |
| UI System | Material Design |
| Local Storage | SharedPreferences |
| Data Encoding | JSON |

---

## 📱 Application Flow

1. User sets or updates current balance  
2. User adds expenses  
3. System validates available balance  
4. Balance updates automatically  
5. Data persists locally  
6. Chart reflects expense distribution  

---

## 📂 Project Structure

```
lib/
│
├── models/
│   └── expense.dart
│
├── widgets/
│   ├── chart.dart
│   ├── expense_list.dart
│   ├── new_expense.dart
│   └── new_balance.dart
│
├── main.dart
```

---

## 🔐 Business Logic Rules

- Expenses cannot exceed available balance  
- Balance updates instantly after expense creation  
- Deleted expenses can be restored  
- Data persists between sessions  

---

## 📦 Installation

```bash
git clone https://github.com/your-username/hasebha.git
cd hasebha
flutter pub get
flutter run
```

---

## 🚀 Future Roadmap

- Monthly & yearly analytics  
- Advanced statistics dashboard  
- Budget goals with alerts  
- Data export (CSV / PDF)  
- Cloud synchronization (Firebase)  
- Multi-device sync  

---

## 📄 License

This project is open-source and available under the MIT License.
