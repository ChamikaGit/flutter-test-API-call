import 'dart:convert';

import 'package:flutter_bloc_sample_api/features/post/models/post_data_model.dart';
import 'package:http/http.dart' as http;

/**
    This repo used the easy to handle the error using the Exception
 **/
class PostRepo {
  static Future<List<PostDataModel>> fetchAllPosts() async {
    var client = http.Client();
    try {
      var response = await client
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

      if (response.statusCode == 200) {
        // Parse JSON string into a dynamic List
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => PostDataModel.fromJson(item)).toList();
      } else if (response.statusCode == 400) {
        // Handle 400 status code with a specific message
        throw Exception('Bad Request: Invalid data sent to the server.');
      } else {
        // Handle other non-200 status codes
        throw Exception(
            'Failed to fetch posts. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Rethrow exceptions to be handled in the Bloc
      throw Exception('Error occurred: ${e.toString()}');
    } finally {
      client.close(); // Ensure the client is closed
    }
  }

  static Future<bool> addPost() async {
    var client = http.Client();
    try {
      var response = await client
          .post(Uri.parse("https://jsonplaceholder.typicode.com/posts"),body: {
        "title": 'Chamika flutter test post',
        "body": 'Chamika flutter test post body',
        "userId": '1',
      });

      if (response.statusCode >=200 && response.statusCode<300) {
        return true;
      } else if (response.statusCode == 400) {
        // Handle 400 status code with a specific message
        return false;
        throw Exception('Bad Request: Invalid data sent to the server.');
      } else {
        return false;
        // Handle other non-200 status codes
        throw Exception(
            'Failed to fetch posts. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Rethrow exceptions to be handled in the Bloc
      throw Exception('Error occurred: ${e.toString()}');
    } finally {
      client.close(); // Ensure the client is closed
    }
  }
}
