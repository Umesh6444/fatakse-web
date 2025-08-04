# StageLink MVP

StageLink is a comprehensive platform that connects artists, clients, vendors, event planners, and production houses in the creative economy. It's built with Flutter and Firebase to provide a seamless experience for discovering, booking, and managing creative services.

## 🎯 Vision

"The backstage platform powering the show" - StageLink aims to be the one-stop solution for all creative and entertainment industry needs, from individual gig bookings to large-scale production management.

## 👥 User Roles

- **Artists**: Singers, dancers, DJs, photographers, makeup artists, etc.
- **Household Clients**: Book artists for personal events like birthdays, weddings
- **Corporate Clients**: Book services for corporate events, launches, conferences
- **Vendors**: Equipment rental providers (sound, lighting, cameras, etc.)
- **Event Planners**: Professionals who manage events and source talent/equipment
- **Production Houses**: Film, TV, and media production companies

## 🚀 Core Features

### Phase 1 (MVP)
- [x] Multi-role authentication system
- [x] User profile creation with role-specific data
- [x] Basic UI/UX with material design
- [ ] Artist ↔ Household Client booking system
- [ ] Vendor equipment listing and rental
- [ ] In-app messaging system
- [ ] Razorpay payment integration
- [ ] Basic search and discovery
- [ ] Review and rating system

### Phase 2 (Growth)
- [ ] Event Planner tools and workflows
- [ ] Production House project management
- [ ] Advanced search with filters
- [ ] Location-based discovery
- [ ] Push notifications
- [ ] Calendar integration
- [ ] Contract generation
- [ ] Multi-party bookings

### Phase 3 (Scale)
- [ ] AI-powered recommendations
- [ ] Video calling integration
- [ ] Advanced analytics dashboard
- [ ] Subscription plans
- [ ] API for third-party integrations
- [ ] White-label solutions

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Auth, Functions, Storage)
- **State Management**: BLoC Pattern
- **Navigation**: GoRouter
- **UI Framework**: Material Design 3
- **Payments**: Razorpay
- **Local Storage**: Hive + SharedPreferences
- **Dependency Injection**: GetIt + Injectable
- **Testing**: Flutter Test + Mockito

## 📱 App Architecture

```
lib/
├── core/                 # Core utilities and constants
│   ├── constants/        # App constants and enums
│   ├── errors/          # Error handling
│   ├── network/         # Network utilities
│   └── utils/           # Helper functions
├── config/              # App configuration
│   ├── routes/          # Navigation and routing
│   └── theme/           # App theme and styling
├── features/            # Feature modules
│   ├── auth/            # Authentication
│   ├── booking/         # Booking system
│   ├── chat/            # Messaging
│   ├── home/            # Home dashboard
│   ├── profile/         # User profiles
│   ├── search/          # Search and discovery
│   └── vendor/          # Vendor marketplace
└── shared/              # Shared components
    ├── models/          # Data models
    ├── services/        # Business logic services
    └── widgets/         # Reusable UI components
```

## 💰 Business Model

### Revenue Streams
- **Commission on Bookings**: 10-15% from artists, 5-10% from vendors
- **Featured Listings**: ₹99-₹999/month for premium placement
- **Subscription Plans**: ₹499-₹1499/month for advanced features
- **Service Bundles**: Combo deals (DJ + Sound + Lighting)
- **Corporate Contracts**: Monthly retainers for enterprise clients

### Target Market
- Tier 1/2 cities in India
- Event industry professionals
- Individual event organizers
- Corporate event managers
- Content creators and influencers

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (3.24.0 or higher)
- Dart SDK (3.8.0 or higher)
- Firebase CLI
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/fatakse_prod.git
   cd fatakse_prod
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   ```bash
   # Install Firebase CLI if not already installed
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Generate code**
   ```bash
   dart run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Firebase Configuration

Update the Firebase configuration in `lib/firebase_options.dart` with your actual Firebase project credentials:

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS apps to your project
3. Download configuration files and run `flutterfire configure`
4. Enable Authentication, Firestore, and Storage in Firebase Console

### Environment Setup

Create a `.env` file in the root directory:
```
RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_key_secret
```

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Generate test coverage
flutter test --coverage
```

## 📝 API Documentation

### Firestore Collections

- `users` - User profiles with role-specific data
- `bookings` - Booking requests and confirmations
- `vendors` - Equipment and service listings
- `messages` - Chat messages between users
- `events` - Event postings and requirements
- `reviews` - User reviews and ratings

### Key Models

- `UserModel` - Base user information with role-specific extensions
- `BookingModel` - Booking details and status
- `VendorModel` - Vendor and equipment information
- `MessageModel` - Chat message structure

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Email: support@stagelink.app
- GitHub Issues: [Create an issue](https://github.com/your-username/fatakse_prod/issues)

## 🗺 Roadmap

- [x] Q1 2025: MVP Launch with basic booking system
- [ ] Q2 2025: Vendor marketplace and equipment rental
- [ ] Q3 2025: Event planner tools and production house features
- [ ] Q4 2025: AI recommendations and advanced analytics

---

**Made with ❤️ for the creative community**
