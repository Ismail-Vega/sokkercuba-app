import 'package:json_annotation/json_annotation.dart';

part 'full_name.g.dart';

@JsonSerializable()
class FullName {
  String name;
  String surname;
  String full;

  FullName({
    required this.name,
    required this.surname,
    required this.full,
  });

  factory FullName.fromJson(Map<String, dynamic> json) =>
      _$FullNameFromJson(json);

  Map<String, dynamic> toJson() => _$FullNameToJson(this);
}
