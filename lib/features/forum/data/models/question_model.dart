import 'package:json_annotation/json_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../library/data/models/tag_model.dart';

part 'question_model.g.dart';

@JsonSerializable()
class QuestionModel {
  final String id;
  final String title;
  final String content;
  @JsonKey(name: 'authorId')
  final String authorId;
  final UserModel? author;
  final List<TagModel> tags;
  @JsonKey(name: 'viewCount')
  final int viewCount;
  @JsonKey(name: 'answerCount')
  final int answerCount;
  @JsonKey(name: 'hasAcceptedAnswer')
  final bool hasAcceptedAnswer;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  QuestionModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    this.author,
    required this.tags,
    required this.viewCount,
    required this.answerCount,
    required this.hasAcceptedAnswer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable()
class AnswerModel {
  final String id;
  @JsonKey(name: 'questionId')
  final String questionId;
  final String content;
  @JsonKey(name: 'authorId')
  final String authorId;
  final UserModel? author;
  @JsonKey(name: 'upvoteCount')
  final int upvoteCount;
  @JsonKey(name: 'isAccepted')
  final bool isAccepted;
  @JsonKey(name: 'isUpvotedByCurrentUser')
  final bool? isUpvotedByCurrentUser;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.content,
    required this.authorId,
    this.author,
    required this.upvoteCount,
    required this.isAccepted,
    this.isUpvotedByCurrentUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}
