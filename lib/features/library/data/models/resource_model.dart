import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import 'tag_model.dart';

part 'resource_model.g.dart';

enum ResourceStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

@JsonSerializable()
class ResourceModel {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'driveFileId')
  final String driveFileId;
  @JsonKey(name: 'mimeType')
  final String mimeType;
  @JsonKey(name: 'fileSize')
  final int fileSize;
  final String? thumbnail;
  final ResourceStatus status;
  @JsonKey(name: 'uploaderId')
  final String uploaderId;
  final UserModel? uploader;
  final List<TagModel> tags;
  @JsonKey(name: 'viewCount')
  final int viewCount;
  @JsonKey(name: 'downloadCount')
  final int downloadCount;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  ResourceModel({
    required this.id,
    required this.title,
    this.description,
    required this.driveFileId,
    required this.mimeType,
    required this.fileSize,
    this.thumbnail,
    required this.status,
    required this.uploaderId,
    this.uploader,
    required this.tags,
    required this.viewCount,
    required this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceModelToJson(this);

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

@JsonSerializable()
class PaginatedResourceResponse {
  final List<ResourceModel> data;
  final int total;
  final int page;
  final int limit;

  PaginatedResourceResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedResourceResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResourceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedResourceResponseToJson(this);

  bool get hasMore => (page * limit) < total;
}
