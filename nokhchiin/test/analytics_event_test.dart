import 'package:flutter_test/flutter_test.dart';
import 'package:nokhchiin/domain/entities/analytics_event.dart';

void main() {
  test('analytics event serializes roundtrip', () {
    final event = AnalyticsEvent(
      name: AnalyticsEventName.paywallViewed,
      timestamp: DateTime(2026, 1, 1),
      properties: {'return_path': '/path'},
    );
    final restored = AnalyticsEvent.fromJson(event.toJson());
    expect(restored.name, AnalyticsEventName.paywallViewed);
    expect(restored.properties['return_path'], '/path');
  });

  test('paywall funnel event ids are unique', () {
    final ids = AnalyticsEventName.values.map((e) => e.id).toSet();
    expect(ids.length, AnalyticsEventName.values.length);
  });
}
