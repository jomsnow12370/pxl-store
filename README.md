# pxl-store

Pixel game-like store inventory and point of sale system for clothing brand.

A Flutter application with a pixel-themed neobrutalist design, built to help small clothing businesses manage inventory, track sales, and manage expenses.

## Features

- 🎨 **Pixel-themed UI** with neobrutalist design using Press Start 2P font
- 📦 **Inventory Management** - Add products with variations (color, size, quantity)
- 🛒 **Point of Sale (POS)** - Quick checkout and receipts (coming soon)
- 💰 **Sales Tracking** - Track daily and monthly sales (coming soon)
- 📊 **Expense Management** - Record costs and suppliers (coming soon)
- 🌐 **Cross-platform** - Runs on iOS, Android, and Web

## Tech Stack

### Frontend
- Flutter
- Google Fonts (Press Start 2P)
- HTTP package for API communication

### Backend
- Node.js + Express.js
- MySQL database
- RESTful API

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Node.js and npm
- MySQL database
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/jomsnow12370/pxl-store.git
cd pxl-store
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Set up the backend (see [backend README](../mrhy-pxl-store-backend/README.md)):
```bash
cd ../mrhy-pxl-store-backend
npm install
npm run init-db
npm start
```

4. Run the Flutter app:
```bash
cd ../mrhy-pxl-store
flutter run
```

## Project Structure

```
mrhy-pxl-store/
├── lib/
│   ├── main.dart          # Main application entry point
│   └── services/
│       └── api_service.dart  # Backend API communication
├── pubspec.yaml          # Flutter dependencies
└── README.md
```

## Backend Repository

The backend API is in a separate repository: `mrhy-pxl-store-backend`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available for personal/commercial use.
