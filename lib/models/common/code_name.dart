import 'package:json_annotation/json_annotation.dart';

part 'code_name.g.dart';

@JsonSerializable()
class CodeName {
  int code;
  String name;

  CodeName({
    required this.code,
    required this.name,
  });

  factory CodeName.fromJson(Map<String, dynamic> json) =>
      _$CodeNameFromJson(json);

  Map<String, dynamic> toJson() => _$CodeNameToJson(this);
}
