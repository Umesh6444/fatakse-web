import 'package:fatakse_prod/shared/models/user_model.dart';

class TestUserData {
  static final now = DateTime.now();

  static UserModel artist = UserModel(
    id: 'artist1',
    email: 'artist1@example.com',
    firstName: 'Artist',
    lastName: 'One',
    role: 'artist',
    createdAt: now,
    updatedAt: now,
  );

  static UserModel vendor = UserModel(
    id: 'vendor1',
    email: 'vendor1@example.com',
    firstName: 'Vendor',
    lastName: 'One',
    role: 'vendor',
    createdAt: now,
    updatedAt: now,
  );

  static UserModel eventPlanner = UserModel(
    id: 'planner1',
    email: 'planner1@example.com',
    firstName: 'Planner',
    lastName: 'One',
    role: 'event_planner',
    createdAt: now,
    updatedAt: now,
  );

  static UserModel productionHouse = UserModel(
    id: 'prodhouse1',
    email: 'prodhouse1@example.com',
    firstName: 'Prod',
    lastName: 'House',
    role: 'production_house',
    createdAt: now,
    updatedAt: now,
  );

  static UserModel householdClient = UserModel(
    id: 'client1',
    email: 'client1@example.com',
    firstName: 'Client',
    lastName: 'One',
    role: 'household_client',
    createdAt: now,
    updatedAt: now,
  );

  static UserModel corporateClient = UserModel(
    id: 'corp1',
    email: 'corp1@example.com',
    firstName: 'Corp',
    lastName: 'Client',
    role: 'corporate_client',
    createdAt: now,
    updatedAt: now,
  );
}
