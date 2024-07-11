import 'package:json_annotation/json_annotation.dart';

part 'cards.g.dart';

@JsonSerializable()
class Cards {
  int cards;
  int yellow;
  int red;

  Cards({
    required this.cards,
    required this.yellow,
    required this.red,
  });

  factory Cards.fromJson(Map<String, dynamic> json) => _$CardsFromJson(json);

  Map<String, dynamic> toJson() => _$CardsToJson(this);
}
