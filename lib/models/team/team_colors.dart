import 'package:json_annotation/json_annotation.dart';

import 'color.dart';

part 'team_colors.g.dart';

@JsonSerializable()
class TeamColors {
  final Color first;
  final Color second;
  final Color keeper;

  TeamColors({required this.first, required this.second, required this.keeper});

  factory TeamColors.fromJson(Map<String, dynamic> json) =>
      _$TeamColorsFromJson(json);
  Map<String, dynamic> toJson() => _$TeamColorsToJson(this);
}
