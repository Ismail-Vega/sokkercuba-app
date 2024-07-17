// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juniors_training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuniorsTraining _$JuniorsTrainingFromJson(Map<String, dynamic> json) =>
    JuniorsTraining(
      juniors: (json['juniors'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), JuniorProgress.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$JuniorsTrainingToJson(JuniorsTraining instance) =>
    <String, dynamic>{
      'juniors': instance.juniors.map((k, e) => MapEntry(k.toString(), e)),
    };
