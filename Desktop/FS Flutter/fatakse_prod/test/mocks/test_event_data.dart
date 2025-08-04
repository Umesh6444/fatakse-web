// Example test event data for event planner/production house tests
class TestEventData {
  static Map<String, dynamic> sampleEvent = {
    'id': 'event1',
    'name': 'Sample Event',
    'organizerId': 'planner1',
    'date': DateTime.now().add(Duration(days: 7)),
    'location': 'Test Venue',
    'status': 'upcoming',
  };
}
