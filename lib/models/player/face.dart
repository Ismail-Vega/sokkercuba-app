import 'package:json_annotation/json_annotation.dart';

part 'face.g.dart';

@JsonSerializable()
class Face {
  int face;
  int skinColor;
  int hairColor;
  int hair;
  int eyes;
  int nose;
  int beard;
  int beardColor;
  int shirt;
  int mouth;

  Face({
    required this.face,
    required this.skinColor,
    required this.hairColor,
    required this.hair,
    required this.eyes,
    required this.nose,
    required this.beard,
    required this.beardColor,
    required this.shirt,
    required this.mouth,
  });

  factory Face.fromJson(Map<String, dynamic> json) => _$FaceFromJson(json);

  Map<String, dynamic> toJson() => _$FaceToJson(this);
}
