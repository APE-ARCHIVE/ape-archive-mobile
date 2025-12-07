// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      author: json['author'] == null
          ? null
          : UserModel.fromJson(json['author'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewCount: (json['viewCount'] as num).toInt(),
      answerCount: (json['answerCount'] as num).toInt(),
      hasAcceptedAnswer: json['hasAcceptedAnswer'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
      'author': instance.author,
      'tags': instance.tags,
      'viewCount': instance.viewCount,
      'answerCount': instance.answerCount,
      'hasAcceptedAnswer': instance.hasAcceptedAnswer,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => AnswerModel(
  id: json['id'] as String,
  questionId: json['questionId'] as String,
  content: json['content'] as String,
  authorId: json['authorId'] as String,
  author: json['author'] == null
      ? null
      : UserModel.fromJson(json['author'] as Map<String, dynamic>),
  upvoteCount: (json['upvoteCount'] as num).toInt(),
  isAccepted: json['isAccepted'] as bool,
  isUpvotedByCurrentUser: json['isUpvotedByCurrentUser'] as bool?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AnswerModelToJson(AnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'content': instance.content,
      'authorId': instance.authorId,
      'author': instance.author,
      'upvoteCount': instance.upvoteCount,
      'isAccepted': instance.isAccepted,
      'isUpvotedByCurrentUser': instance.isUpvotedByCurrentUser,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
