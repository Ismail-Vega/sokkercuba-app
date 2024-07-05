import 'package:json_annotation/json_annotation.dart';

part 'lock.g.dart';

@JsonSerializable()
class Lock {
  bool transfersLocked;
  bool readOnlyMode;

  Lock({
    required this.transfersLocked,
    required this.readOnlyMode,
  });

  factory Lock.fromJson(Map<String, dynamic> json) => _$LockFromJson(json);

  Map<String, dynamic> toJson() => _$LockToJson(this);
}
