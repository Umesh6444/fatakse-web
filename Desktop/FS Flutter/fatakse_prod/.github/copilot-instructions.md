# StageLink MVP - Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
StageLink is a Flutter mobile application that connects artists, clients, vendors, event planners, and production houses in the creative economy. It's built with Firebase backend and includes role-based authentication, booking systems, vendor listings, messaging, and payment integration.

## Architecture Guidelines
- Follow Clean Architecture principles with proper separation of concerns
- Use BLoC pattern for state management
- Implement Repository pattern for data layer
- Use dependency injection with GetIt
- Follow MVVM architecture where applicable

## Key Technologies
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Auth, Functions, Storage)
- **State Management**: Flutter BLoC
- **Payments**: Razorpay
- **Navigation**: GoRouter
- **Dependency Injection**: GetIt
- **Local Storage**: Hive/SharedPreferences

## User Roles
1. **Artist** - Create profiles, accept bookings, manage availability
2. **Household Client** - Book artists for personal events
3. **Corporate Client** - Book bulk services, manage projects
4. **Vendor** - List equipment/services, manage rentals
5. **Event Planner** - Source talent and equipment, manage events
6. **Production House** - Post projects, manage crew

## Code Structure
- `/lib/core/` - Core utilities, constants, extensions
- `/lib/features/` - Feature-based modules (auth, booking, chat, etc.)
- `/lib/shared/` - Shared widgets, services, models
- `/lib/config/` - App configuration, themes, routes

## Firebase Collections Structure
- `users` - All user profiles with role-based data
- `bookings` - Booking requests and confirmations
- `vendors` - Equipment and service listings
- `messages` - Chat messages between users
- `events` - Event postings and requirements
- `reviews` - User reviews and ratings

## Payment Flow
- Razorpay integration for secure payments
- Milestone-based payments for larger projects
- Commission-based revenue model (10-15% for artists, 5-10% for vendors)

## Best Practices
- Always validate user permissions based on roles
- Implement proper error handling and loading states
- Use responsive design for different screen sizes
- Follow material design guidelines
- Implement offline support where possible
- Add proper logging and analytics
