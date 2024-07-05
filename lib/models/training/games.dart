import 'package:json_annotation/json_annotation.dart';

part 'games.g.dart';

@JsonSerializable()
class Games {
  int minutesOfficial;
  int minutesFriendly;
  int minutesNational;

  Games(
      {required this.minutesOfficial,
      required this.minutesFriendly,
      required this.minutesNational});

  factory Games.fromJson(Map<String, dynamic> json) => _$GamesFromJson(json);
  Map<String, dynamic> toJson() => _$GamesToJson(this);
}
