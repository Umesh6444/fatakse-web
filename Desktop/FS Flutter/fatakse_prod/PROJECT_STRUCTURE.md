# StageLink Project Structure

## 📁 Current Project Layout

```
fatakse_prod/
├── .github/
│   └── copilot-instructions.md     # Copilot workspace instructions
├── .vscode/
│   └── tasks.json                  # VS Code tasks configuration
├── lib/
│   ├── config/
│   │   └── theme/
│   │       └── app_theme.dart      # App theme and colors
│   ├── core/
│   │   └── constants/
│   │       └── app_constants.dart  # App-wide constants
│   ├── shared/
│   │   └── models/
│   │       ├── user_model.dart     # User data model
│   │       ├── user_model.g.dart   # Generated JSON serialization
│   │       ├── booking_model.dart  # Booking data model
│   │       └── booking_model.g.dart # Generated JSON serialization
│   ├── main.dart                   # App entry point
│   └── firebase_options.dart       # Firebase configuration
├── test/
│   └── widget_test.dart            # Widget tests
├── pubspec.yaml                    # Dependencies and project config
└── README.md                       # Project documentation
```

## 🚀 Current Features

### ✅ Implemented
- **Project Setup**: Flutter project with proper dependencies
- **Firebase Integration**: Basic Firebase setup (needs actual configuration)
- **Material Design**: Custom theme with role-based colors
- **Model Architecture**: User and Booking models with JSON serialization
- **Welcome Screen**: Basic onboarding UI
- **Testing**: Widget tests for main components

### 🔄 Next Steps (Not Yet Implemented)
1. **Authentication System**
   - Firebase Auth integration
   - Role-based signup/login
   - User profile management

2. **Navigation & Routing**
   - GoRouter setup
   - Route guards based on authentication
   - Role-based navigation

3. **Core Features**
   - Artist-Client booking system
   - Vendor marketplace
   - In-app messaging
   - Payment integration (Razorpay)
   - Search and discovery

4. **State Management**
   - BLoC implementation
   - Repository pattern
   - Dependency injection setup

## 🛠 Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code (JSON serialization, etc.)
dart run build_runner build

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Build for release
flutter build apk --release
flutter build ios --release
```

## 🔧 Firebase Setup Required

To complete the Firebase integration:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS apps to your project
3. Download configuration files
4. Run `flutterfire configure` to generate proper `firebase_options.dart`
5. Enable Authentication, Firestore, and Storage in Firebase Console

## 📝 Key Dependencies

- **flutter_bloc**: State management
- **firebase_core**: Firebase core functionality
- **cloud_firestore**: Database
- **firebase_auth**: Authentication
- **razorpay_flutter**: Payment processing
- **go_router**: Navigation
- **flutter_screenutil**: Responsive design
- **get_it**: Dependency injection
- **json_annotation**: JSON serialization

## 🎯 Business Logic

### User Roles
- **Artist**: Performers, photographers, makeup artists, etc.
- **Household Client**: Individual event organizers
- **Corporate Client**: Business event managers
- **Vendor**: Equipment rental providers
- **Event Planner**: Professional event organizers
- **Production House**: Film/media production companies

### Revenue Model
- Commission on bookings (10-15% artists, 5-10% vendors)
- Featured listings (₹99-₹999/month)
- Premium subscriptions (₹499-₹1499/month)
- Service bundles and corporate contracts

## 🚦 Current Status

✅ **Foundation**: Project structure, models, and theme ready
🔄 **In Progress**: Authentication and navigation system
📋 **Planned**: Core booking features, messaging, payments

The project is ready for the next phase of development with authentication, routing, and core feature implementation.
