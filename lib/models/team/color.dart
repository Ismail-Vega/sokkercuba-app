import 'package:json_annotation/json_annotation.dart';

import '../common/code_name.dart';
import 'shirt.dart';
import 'trousers.dart';

part 'color.g.dart';

@JsonSerializable()
class Color {
  final Shirt shirt;
  final Trousers trousers;
  final CodeName type;

  Color({required this.shirt, required this.trousers, required this.type});

  factory Color.fromJson(Map<String, dynamic> json) => _$ColorFromJson(json);
  Map<String, dynamic> toJson() => _$ColorToJson(this);
}
