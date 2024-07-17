import 'package:json_annotation/json_annotation.dart';

part 'progress_value.g.dart';

@JsonSerializable()
class ProgressValue {
  final int x;
  final int y;
  final int scale;

  ProgressValue({
    required this.x,
    required this.y,
    required this.scale,
  });

  factory ProgressValue.fromJson(Map<String, dynamic> json) =>
      _$ProgressValueFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressValueToJson(this);
}
