import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

enum TagType {
  @JsonValue('GRADE')
  grade,
  @JsonValue('SUBJECT')
  subject,
  @JsonValue('LESSON')
  lesson,
  @JsonValue('MEDIUM')
  medium,
  @JsonValue('RESOURCE_TYPE')
  resourceType,
}

@JsonSerializable()
class TagModel {
  final String id;
  final String name;
  final TagType type;
  final String? description;
  @JsonKey(name: 'parentId')
  final String? parentId;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  TagModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.parentId,
    required this.createdAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}

@JsonSerializable()
class TagHierarchyNode {
  final TagModel tag;
  final List<TagHierarchyNode> children;

  TagHierarchyNode({
    required this.tag,
    required this.children,
  });

  factory TagHierarchyNode.fromJson(Map<String, dynamic> json) =>
      _$TagHierarchyNodeFromJson(json);

  Map<String, dynamic> toJson() => _$TagHierarchyNodeToJson(this);
}
