import 'package:json_annotation/json_annotation.dart';

import 'junior_progress.dart';

part 'juniors_training.g.dart';

@JsonSerializable()
class JuniorsTraining {
  final Map<int, JuniorProgress> juniors;

  JuniorsTraining({required this.juniors});

  factory JuniorsTraining.fromJson(Map<String, dynamic> json) =>
      _$JuniorsTrainingFromJson(json);

  Map<String, dynamic> toJson() => _$JuniorsTrainingToJson(this);
}
