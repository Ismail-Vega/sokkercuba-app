import 'package:json_annotation/json_annotation.dart';

part 'player_wage.g.dart';

@JsonSerializable()
class Wage {
  int value;
  String currency;

  Wage({
    required this.value,
    required this.currency,
  });

  factory Wage.fromJson(Map<String, dynamic> json) => _$WageFromJson(json);

  Map<String, dynamic> toJson() => _$WageToJson(this);
}
