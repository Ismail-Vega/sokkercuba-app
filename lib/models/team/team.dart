import 'package:json_annotation/json_annotation.dart';

import '../common/code_name.dart';
import 'team_colors.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  int id;
  String? name;
  int? rank;
  String? emblem;
  CodeName? country;
  TeamColors? colors;
  int? nationalType;
  bool? bankrupt;

  Team({
    required this.id,
    required this.name,
    required this.rank,
    required this.emblem,
    required this.country,
    required this.colors,
    required this.nationalType,
    required this.bankrupt,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
