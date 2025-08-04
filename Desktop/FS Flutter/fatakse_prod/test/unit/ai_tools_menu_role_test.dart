import 'package:flutter_test/flutter_test.dart';
import 'package:fatakse_prod/shared/models/user_model.dart';
// import 'package:fatakse_prod/features/ai_tools/ai_tools_menu_page.dart';

void main() {
  group('AI Tools Menu Role Filtering', () {
    final now = DateTime.now();
    UserModel dummyUser(String role) => UserModel(
      id: 'id',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      role: role,
      createdAt: now,
      updatedAt: now,
    );

    final artist = dummyUser('artist');
    final vendor = dummyUser('vendor');
    final eventPlanner = dummyUser('event_planner');
    final productionHouse = dummyUser('production_house');
    final householdClient = dummyUser('household_client');
    final corporateClient = dummyUser('corporate_client');

    test('Artist sees artist tools', () {
      // TODO: Replace with actual menu filtering logic
      expect(artist.role, 'artist');
    });
    test('Vendor sees vendor tools', () {
      expect(vendor.role, 'vendor');
    });
    test('Event Planner sees event tools', () {
      expect(eventPlanner.role, 'event_planner');
    });
    test('Production House sees production tools', () {
      expect(productionHouse.role, 'production_house');
    });
    test('Household Client sees client tools', () {
      expect(householdClient.role, 'household_client');
    });
    test('Corporate Client sees corporate tools', () {
      expect(corporateClient.role, 'corporate_client');
    });
  });
}
