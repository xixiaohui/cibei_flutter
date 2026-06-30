import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../network/dio_client.dart';
import '../constants/api_endpoints.dart';

class PosterRepository {
  final Dio _dio;

  PosterRepository() : _dio = createDioClient();

  /// Downloads a share poster image from the API.
  /// Returns the local file path of the downloaded poster.
  /// [type] — one of: 'sutra', 'dictionary', 'encyclopedia', 'story'
  /// [slug] — the content slug
  Future<String> downloadPoster(String type, String slug) async {
    final url = ApiEndpoints.poster(type, slug);

    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Poster image is empty');
    }

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/poster_${type}_$slug.png');
    await file.writeAsBytes(bytes);

    return file.path;
  }
}

final posterRepositoryProvider = Provider<PosterRepository>(
  (ref) => PosterRepository(),
);
