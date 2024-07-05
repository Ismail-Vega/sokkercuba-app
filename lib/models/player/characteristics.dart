import 'package:json_annotation/json_annotation.dart';

part 'characteristics.g.dart';

@JsonSerializable()
class Characteristics {
  int age;
  int height;
  int weight;
  double bmi;

  Characteristics({
    required this.age,
    required this.height,
    required this.weight,
    required this.bmi,
  });

  factory Characteristics.fromJson(Map<String, dynamic> json) =>
      _$CharacteristicsFromJson(json);

  Map<String, dynamic> toJson() => _$CharacteristicsToJson(this);
}
