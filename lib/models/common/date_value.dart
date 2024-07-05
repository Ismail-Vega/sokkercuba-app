import 'package:json_annotation/json_annotation.dart';

part 'date_value.g.dart';

@JsonSerializable()
class DateValue {
  String value;
  int timestamp;

  DateValue({
    required this.value,
    required this.timestamp,
  });

  factory DateValue.fromJson(Map<String, dynamic> json) =>
      _$DateValueFromJson(json);

  Map<String, dynamic> toJson() => _$DateValueToJson(this);
}
