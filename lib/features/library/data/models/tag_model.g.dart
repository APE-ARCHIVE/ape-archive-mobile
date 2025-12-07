// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) => TagModel(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$TagTypeEnumMap, json['type']),
  description: json['description'] as String?,
  parentId: json['parentId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$TagTypeEnumMap[instance.type]!,
  'description': instance.description,
  'parentId': instance.parentId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TagTypeEnumMap = {
  TagType.grade: 'GRADE',
  TagType.subject: 'SUBJECT',
  TagType.lesson: 'LESSON',
  TagType.medium: 'MEDIUM',
  TagType.resourceType: 'RESOURCE_TYPE',
};

TagHierarchyNode _$TagHierarchyNodeFromJson(Map<String, dynamic> json) =>
    TagHierarchyNode(
      tag: TagModel.fromJson(json['tag'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>)
          .map((e) => TagHierarchyNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TagHierarchyNodeToJson(TagHierarchyNode instance) =>
    <String, dynamic>{'tag': instance.tag, 'children': instance.children};
