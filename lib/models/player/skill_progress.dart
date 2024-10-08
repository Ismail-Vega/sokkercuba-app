import 'package:json_annotation/json_annotation.dart';

part 'skill_progress.g.dart';

@JsonSerializable()
class SkillProgress {
  final SkillValue stamina;
  final SkillValue keeper;
  final SkillValue playmaking;
  final SkillValue passing;
  final SkillValue technique;
  final SkillValue defending;
  final SkillValue striker;
  final SkillValue pace;

  SkillProgress({
    required this.stamina,
    required this.keeper,
    required this.playmaking,
    required this.passing,
    required this.technique,
    required this.defending,
    required this.striker,
    required this.pace,
  });

  factory SkillProgress.fromJson(Map<String, dynamic> json) =>
      _$SkillProgressFromJson(json);
  Map<String, dynamic> toJson() => _$SkillProgressToJson(this);

  SkillValue getSkillValue(String skill) {
    switch (skill) {
      case 'stamina':
        return stamina;
      case 'keeper':
        return keeper;
      case 'playmaking':
        return playmaking;
      case 'passing':
        return passing;
      case 'technique':
        return technique;
      case 'defending':
        return defending;
      case 'striker':
        return striker;
      case 'pace':
        return pace;
      default:
        return SkillValue(current: 0.0, next: 0.0);
    }
  }

  SkillProgress copyWith({
    SkillValue? stamina,
    SkillValue? keeper,
    SkillValue? playmaking,
    SkillValue? passing,
    SkillValue? technique,
    SkillValue? defending,
    SkillValue? striker,
    SkillValue? pace,
  }) {
    return SkillProgress(
      stamina: stamina ?? this.stamina,
      keeper: keeper ?? this.keeper,
      playmaking: playmaking ?? this.playmaking,
      passing: passing ?? this.passing,
      technique: technique ?? this.technique,
      defending: defending ?? this.defending,
      striker: striker ?? this.striker,
      pace: pace ?? this.pace,
    );
  }
}

@JsonSerializable()
class SkillValue {
  final double current;
  final double next;

  SkillValue({required this.current, required this.next});

  factory SkillValue.fromJson(Map<String, dynamic> json) =>
      _$SkillValueFromJson(json);
  Map<String, dynamic> toJson() => _$SkillValueToJson(this);

  SkillValue copyWith({
    double? current,
    double? next,
  }) {
    return SkillValue(
      current: current ?? this.current,
      next: next ?? this.next,
    );
  }
}
