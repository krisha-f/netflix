// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../Models/pagination.dart';
//
// class NetworkService {
//   final String baseUrl;
//
//   NetworkService({required this.baseUrl});
//
//   Future<List<Post>> fetchPosts({required int page, int limit = 10}) async {
//     final url = Uri.parse("$baseUrl/posts?_page=$page&_limit=$limit");
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//       return data.map((e) => Post.fromJson(e)).toList();
//     } else {
//       throw Exception("Failed to load posts");
//     }
//   }
// }