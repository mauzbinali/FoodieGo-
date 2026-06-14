import 'package:cloud_firestore/cloud_firestore.dart';

DateTime dateTimeFromValue(Object? value, {DateTime? fallback}) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) {
    return DateTime.tryParse(value) ?? fallback ?? DateTime.now();
  }
  return fallback ?? DateTime.now();
}

List<String> stringListFromValue(Object? value) {
  if (value is List) return value.map((item) => item.toString()).toList();
  return [];
}

Map<String, dynamic> mapFromValue(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
