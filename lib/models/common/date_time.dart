import 'package:json_annotation/json_annotation.dart';

part 'date_time.g.dart';

@JsonSerializable()
class DateTime {
  String date;
  @JsonKey(name: 'timezone_type')
  int timezoneType;
  String timezone;

  DateTime(
      {required this.date, required this.timezoneType, required this.timezone});

  factory DateTime.fromJson(Map<String, dynamic> json) =>
      _$DateTimeFromJson(json);

  Map<String, dynamic> toJson() => _$DateTimeToJson(this);
}
