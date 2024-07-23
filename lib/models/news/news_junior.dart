import 'package:json_annotation/json_annotation.dart';

part 'news_junior.g.dart';

@JsonSerializable()
class NewsJunior {
  final int id;
  final String fullName;
  final String position;
  final int age;
  final int weeks;
  final int total;
  final int potential;
  final int potentialMin;
  final int potentialMax;
  final bool active;
  final List<dynamic> actions;

  NewsJunior({
    required this.id,
    required this.fullName,
    required this.position,
    required this.age,
    required this.weeks,
    required this.total,
    required this.potential,
    required this.potentialMin,
    required this.potentialMax,
    required this.active,
    required this.actions,
  });

  factory NewsJunior.fromJson(Map<String, dynamic> json) =>
      _$NewsJuniorFromJson(json);
  Map<String, dynamic> toJson() => _$NewsJuniorToJson(this);
}
