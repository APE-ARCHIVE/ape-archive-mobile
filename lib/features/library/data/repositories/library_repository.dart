import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/resource_model.dart';
import '../models/tag_model.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepository(dio: ref.watch(dioProvider));
});

class LibraryRepository {
  final Dio _dio;

  LibraryRepository({required Dio dio}) : _dio = dio;

  /// Get library hierarchy (Grade -> Subject -> Lesson -> Medium)
  Future<List<TagHierarchyNode>> getHierarchy() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseApiUrl}${ApiConstants.libraryHierarchy}',
      );
      
      // Handle both wrapped and direct response formats
      final responseData = response.data;
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic>) {
        // If response has a 'data' field containing the list
        if (responseData.containsKey('data') && responseData['data'] is List) {
          data = responseData['data'];
        } else {
          throw ServerException(
            message: 'Invalid response format: expected list in data field',
            statusCode: response.statusCode,
          );
        }
      } else if (responseData is List) {
        data = responseData;
      } else {
        throw ServerException(
          message: 'Invalid response format from server',
          statusCode: response.statusCode,
        );
      }
      
      return data.map((json) => TagHierarchyNode.fromJson(json)).toList();
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch hierarchy';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorMessage = 'Cannot connect to server';
      } else if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: null,
      );
    }
  }

  /// Browse resources with filters
  Future<PaginatedResourceResponse> browseResources({
    String? stream,
    String? subject,
    String? grade,
    String? medium,
    String? resourceType,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (stream != null && stream.isNotEmpty) {
        queryParams['stream'] = stream;
      }
      if (subject != null && subject.isNotEmpty) {
        queryParams['subject'] = subject;
      }
      if (grade != null && grade.isNotEmpty) {
        queryParams['grade'] = grade;
      }
      if (medium != null && medium.isNotEmpty) {
        queryParams['medium'] = medium;
      }
      if (resourceType != null && resourceType.isNotEmpty) {
        queryParams['resourceType'] = resourceType;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '${ApiConstants.baseApiUrl}${ApiConstants.libraryBrowse}',
        queryParameters: queryParams,
      );

      // Handle both wrapped and direct response formats
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        // If response has a 'data' field containing the paginated response
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          return PaginatedResourceResponse.fromJson(responseData['data']);
        }
        // Otherwise assume the response itself is the paginated response
        return PaginatedResourceResponse.fromJson(responseData);
      }
      
      throw ServerException(
        message: 'Invalid response format from server',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch resources';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Cannot connect to server. Please try again later.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Authentication required. Please sign in.';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'Access denied.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Resources not found.';
      } else if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
        statusCode: null,
      );
    }
  }

  /// Get resource by ID
  Future<ResourceModel> getResourceById(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseApiUrl}${ApiConstants.resourceById}/$id',
      );
      
      // Handle both wrapped and direct response formats
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        // If response has a 'data' field containing the resource
        if (responseData.containsKey('data') && responseData['data'] is Map) {
          return ResourceModel.fromJson(responseData['data']);
        }
        // Otherwise assume the response itself is the resource
        return ResourceModel.fromJson(responseData);
      }
      
      throw ServerException(
        message: 'Invalid response format from server',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch resource',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Get streaming URL for PDF
  String getStreamingUrl(String resourceId) {
    return '${ApiConstants.baseApiUrl}${ApiConstants.resourceStream}/$resourceId/stream';
  }

  /// Search resources
  Future<PaginatedResourceResponse> searchResources({
    required String query,
    String? stream,
    String? subject,
    String? grade,
    String? medium,
    String? resourceType,
    int page = 1,
    int limit = 20,
  }) async {
    return browseResources(
      search: query,
      stream: stream,
      subject: subject,
      grade: grade,
      medium: medium,
      resourceType: resourceType,
      page: page,
      limit: limit,
    );
  }

  /// Get recent/popular resources
  Future<List<ResourceModel>> getRecentResources({int limit = 10}) async {
    try {
      final response = await browseResources(
        page: 1,
        limit: limit,
      );
      return response.data;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch recent resources');
    }
  }

  /// Get popular resources
  Future<List<ResourceModel>> getPopularResources({int limit = 10}) async {
    try {
      final response = await browseResources(
        page: 1,
        limit: limit,
      );
      return response.data;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch popular resources');
    }
  }
}
