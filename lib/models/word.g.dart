// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
      id: json['id'] as String,
      name: json['name'] as String,
      context: json['context'] as String,
      gesture: json['gesture'] as String,
    );

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'context': instance.context,
      'gesture': instance.gesture,
    };
