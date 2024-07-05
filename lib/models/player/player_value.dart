import 'package:json_annotation/json_annotation.dart';

part 'player_value.g.dart';

@JsonSerializable()
class PlayerValue {
  int value;
  String currency;

  PlayerValue({
    required this.value,
    required this.currency,
  });

  factory PlayerValue.fromJson(Map<String, dynamic> json) =>
      _$PlayerValueFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerValueToJson(this);
}
