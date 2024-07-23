import 'package:json_annotation/json_annotation.dart';

import 'news_junior.dart';

part 'news_block.g.dart';

@JsonSerializable()
class NewsBlock {
  final String type;
  final BlockData data;
  final List<dynamic> actions;

  NewsBlock({
    required this.type,
    required this.data,
    required this.actions,
  });

  factory NewsBlock.fromJson(Map<String, dynamic> json) =>
      _$NewsBlockFromJson(json);
  Map<String, dynamic> toJson() => _$NewsBlockToJson(this);
}

@JsonSerializable()
class BlockData {
  final List<Part> parts;
  final List<NewsJunior> juniors;

  BlockData({
    required this.parts,
    required this.juniors,
  });

  factory BlockData.fromJson(Map<String, dynamic> json) =>
      _$BlockDataFromJson(json);
  Map<String, dynamic> toJson() => _$BlockDataToJson(this);
}

@JsonSerializable()
class Part {
  final String key;
  final dynamic properties;

  Part({
    required this.key,
    required this.properties,
  });

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
  Map<String, dynamic> toJson() => _$PartToJson(this);
}
