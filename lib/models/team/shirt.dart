import 'package:json_annotation/json_annotation.dart';

part 'shirt.g.dart';

@JsonSerializable()
class Shirt {
  final String hex;

  Shirt({required this.hex});

  factory Shirt.fromJson(Map<String, dynamic> json) => _$ShirtFromJson(json);
  Map<String, dynamic> toJson() => _$ShirtToJson(this);
}
