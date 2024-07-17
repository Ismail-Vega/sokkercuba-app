import 'package:json_annotation/json_annotation.dart';

part 'juniors_summary.g.dart';

@JsonSerializable()
class JuniorsSummary {
  int number;
  int skillsUp;

  JuniorsSummary({
    required this.number,
    required this.skillsUp,
  });

  factory JuniorsSummary.fromJson(Map<String, dynamic> json) =>
      _$JuniorsSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$JuniorsSummaryToJson(this);
}
