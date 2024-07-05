import 'package:json_annotation/json_annotation.dart';

part 'injury.g.dart';

@JsonSerializable()
class Injury {
  int daysRemaining;
  bool severe;

  Injury({
    required this.daysRemaining,
    required this.severe,
  });

  factory Injury.fromJson(Map<String, dynamic> json) => _$InjuryFromJson(json);

  Map<String, dynamic> toJson() => _$InjuryToJson(this);
}
