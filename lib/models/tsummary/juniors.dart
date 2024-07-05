import 'package:json_annotation/json_annotation.dart';

part 'juniors.g.dart';

@JsonSerializable()
class Juniors {
  int number;
  int skillsUp;

  Juniors({
    required this.number,
    required this.skillsUp,
  });

  factory Juniors.fromJson(Map<String, dynamic> json) =>
      _$JuniorsFromJson(json);

  Map<String, dynamic> toJson() => _$JuniorsToJson(this);
}
