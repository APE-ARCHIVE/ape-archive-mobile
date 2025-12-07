// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceModel _$ResourceModelFromJson(Map<String, dynamic> json) =>
    ResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      driveFileId: json['driveFileId'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      thumbnail: json['thumbnail'] as String?,
      status: $enumDecode(_$ResourceStatusEnumMap, json['status']),
      uploaderId: json['uploaderId'] as String,
      uploader: json['uploader'] == null
          ? null
          : UserModel.fromJson(json['uploader'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewCount: (json['viewCount'] as num).toInt(),
      downloadCount: (json['downloadCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ResourceModelToJson(ResourceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'driveFileId': instance.driveFileId,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'thumbnail': instance.thumbnail,
      'status': _$ResourceStatusEnumMap[instance.status]!,
      'uploaderId': instance.uploaderId,
      'uploader': instance.uploader,
      'tags': instance.tags,
      'viewCount': instance.viewCount,
      'downloadCount': instance.downloadCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ResourceStatusEnumMap = {
  ResourceStatus.pending: 'PENDING',
  ResourceStatus.approved: 'APPROVED',
  ResourceStatus.rejected: 'REJECTED',
};

PaginatedResourceResponse _$PaginatedResourceResponseFromJson(
  Map<String, dynamic> json,
) => PaginatedResourceResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ResourceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedResourceResponseToJson(
  PaginatedResourceResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
