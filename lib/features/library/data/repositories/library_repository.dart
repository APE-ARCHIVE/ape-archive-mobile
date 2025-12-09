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
      print('📚 Fetching hierarchy from: ${ApiConstants.libraryHierarchy}');
      
      final response = await _dio.get(
        ApiConstants.libraryHierarchy,
      );
      
      print('📚 Hierarchy response status: ${response.statusCode}');
      print('📚 Response data type: ${response.data.runtimeType}');
      
      // Handle both wrapped and direct response formats
      final responseData = response.data;
      
      if (responseData == null) {
        throw ServerException(
          message: 'Server returned null data',
          statusCode: response.statusCode,
        );
      }
      
      List<dynamic> data;
      
      if (responseData is Map<String, dynamic>) {
        print('📚 Response keys: ${responseData.keys.toList()}');
        
        // If response has a 'data' field
        if (responseData.containsKey('data')) {
          final dataField = responseData['data'];
          print('📚 Data field type: ${dataField.runtimeType}');
          
          if (dataField is List) {
            // Standard list format
            data = dataField;
            try {
              return data.map((json) {
                if (json == null) return null;
                return TagHierarchyNode.fromJson(json as Map<String, dynamic>);
              }).whereType<TagHierarchyNode>().toList();
            } catch (e) {
              print('📚 Error parsing hierarchy nodes: $e');
              print('📚 Sample data: ${data.take(1)}');
              throw ServerException(
                message: 'Failed to parse hierarchy data: ${e.toString()}',
                statusCode: response.statusCode,
              );
            }
          } else if (dataField == null) {
            // Return empty list if data is null
            return [];
          } else if (dataField is Map<String, dynamic>) {
            // Nested map format: Parse the hierarchical structure
            print('📚 Parsing nested hierarchy map...');
            return _parseNestedHierarchy(dataField);
          } else {
            print('📚 Data field value: $dataField');
            throw ServerException(
              message: 'Invalid response format: data field is not a list or map (got ${dataField.runtimeType})',
              statusCode: response.statusCode,
            );
          }
        } else {
          print('📚 Available keys: ${responseData.keys.join(", ")}');
          throw ServerException(
            message: 'Invalid response format: missing data field',
            statusCode: response.statusCode,
          );
        }
      } else if (responseData is List) {
        data = responseData;
        try {
          return data.map((json) {
            if (json == null) return null;
            return TagHierarchyNode.fromJson(json as Map<String, dynamic>);
          }).whereType<TagHierarchyNode>().toList();
        } catch (e) {
          print('📚 Error parsing hierarchy nodes: $e');
          print('📚 Sample data: ${data.take(1)}');
          throw ServerException(
            message: 'Failed to parse hierarchy data: ${e.toString()}',
            statusCode: response.statusCode,
          );
        }
      } else {
        print('📚 Response data: $responseData');
        throw ServerException(
          message: 'Invalid response format from server (got ${responseData.runtimeType})',
          statusCode: response.statusCode,
        );
      }
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

      print('📚 Fetching resources from: ${ApiConstants.libraryBrowse}');
      print('📚 Query params: $queryParams');
      
      final response = await _dio.get(
        ApiConstants.libraryBrowse,
        queryParameters: queryParams,
      );
      
      print('📚 Response status: ${response.statusCode}');
      print('📚 Response type: ${response.data.runtimeType}');

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
        message: 'Invalid response format from server. Expected paginated resource data.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch resources from server';
      
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
        '${ApiConstants.resourceById}/$id',
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
    return '${ApiConstants.baseApiUrl}/resources/$resourceId/stream';
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

  /// Parse nested hierarchy map structure from API
  /// Format: { "Grade X": { "Subject": { "Medium": { "ResourceType": [...] } } } }
  List<TagHierarchyNode> _parseNestedHierarchy(Map<String, dynamic> hierarchyMap) {
    final List<TagHierarchyNode> rootNodes = [];
    
    // Level 1: Grades
    hierarchyMap.forEach((gradeName, gradeContent) {
      if (gradeContent is! Map<String, dynamic>) return;
      
      final List<TagHierarchyNode> subjectNodes = [];
      
      // Level 2: Subjects
      gradeContent.forEach((subjectName, subjectContent) {
        if (subjectContent is! Map<String, dynamic>) return;
        
        final List<TagHierarchyNode> mediumNodes = [];
        
        // Level 3: Mediums
        subjectContent.forEach((mediumName, mediumContent) {
          if (mediumContent is! Map<String, dynamic>) return;
          
          final List<TagHierarchyNode> resourceTypeNodes = [];
          
          // Level 4: Resource Types (leaf nodes containing actual resources)
          mediumContent.forEach((resourceTypeName, resources) {
            // Create resource type node (leaf)
            final resourceTypeNode = TagHierarchyNode(
              tag: TagModel(
                id: _generateIdFromName(resourceTypeName),
                name: resourceTypeName,
                type: TagType.resourceType,
              ),
              children: [], // Leaf node
            );
            resourceTypeNodes.add(resourceTypeNode);
          });
          
          // Create medium node
          final mediumNode = TagHierarchyNode(
            tag: TagModel(
              id: _generateIdFromName(mediumName),
              name: mediumName,
              type: TagType.medium,
            ),
            children: resourceTypeNodes,
          );
          mediumNodes.add(mediumNode);
        });
        
        // Create subject node
        final subjectNode = TagHierarchyNode(
          tag: TagModel(
            id: _generateIdFromName(subjectName),
            name: subjectName,
            type: TagType.subject,
          ),
          children: mediumNodes,
        );
        subjectNodes.add(subjectNode);
      });
      
      // Create grade node
      final gradeNode = TagHierarchyNode(
        tag: TagModel(
          id: _generateIdFromName(gradeName),
          name: gradeName,
          type: TagType.grade,
        ),
        children: subjectNodes,
      );
      rootNodes.add(gradeNode);
    });
    
    return rootNodes;
  }

  /// Generate a simple ID from a name (for temporary use)
  String _generateIdFromName(String name) {
    return name.toLowerCase().replaceAll(' ', '-').replaceAll(RegExp(r'[^a-z0-9-]'), '');
  }
}
