import 'package:freezed_annotation/freezed_annotation.dart';
part 'timeline_event.freezed.dart';
part 'timeline_event.g.dart';

@freezed
class TimelineEvent with _$TimelineEvent {
  const factory TimelineEvent({
    required String id,
    required String slug,
    required int year,
    required String yearDisplay,
    required String title,
    required String description,
    required String category,
    String? location,
    required String createdAt,
  }) = _TimelineEvent;

  factory TimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);
}
