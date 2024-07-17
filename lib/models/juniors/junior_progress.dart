import 'package:json_annotation/json_annotation.dart';

import 'progress_value.dart';

part 'junior_progress.g.dart';

@JsonSerializable()
class JuniorProgress {
  final int juniorId;
  final List<ProgressValue> values;

  JuniorProgress({
    required this.juniorId,
    required this.values,
  });

  factory JuniorProgress.fromJson(Map<String, dynamic> json) =>
      _$JuniorProgressFromJson(json);

  Map<String, dynamic> toJson() => _$JuniorProgressToJson(this);
}
