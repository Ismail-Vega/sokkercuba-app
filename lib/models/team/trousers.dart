import 'package:json_annotation/json_annotation.dart';

part 'trousers.g.dart';

@JsonSerializable()
class Trousers {
  final String hex;

  Trousers({required this.hex});

  factory Trousers.fromJson(Map<String, dynamic> json) =>
      _$TrousersFromJson(json);
  Map<String, dynamic> toJson() => _$TrousersToJson(this);
}
