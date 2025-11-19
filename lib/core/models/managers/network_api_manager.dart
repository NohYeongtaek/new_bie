import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/likes_count_entity.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/search_result_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main.dart';

class NetworkApiManager {
  static final NetworkApiManager _shared = NetworkApiManager();

  static NetworkApiManager get shared => _shared;
  final dio = Dio();

  NetworkApiManager() {}

  Future<PostWithProfileEntity> fetchPostItem(int id) async {
    String authorizationKey = supabase.auth.currentSession?.accessToken != null
        ? 'Bearer ${supabase.auth.currentSession?.accessToken}'
        : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc';
    final response = await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts/${id}',
      options: Options(
        headers: {
          'Authorization': authorizationKey,

          'Content-Type': 'application/json',
        },
      ),
    );

    final Map<String, dynamic> data = response.data['data'];
    print("data 데이터 타입 : ${data.runtimeType}");
    final PostWithProfileEntity results = PostWithProfileEntity.fromJson(data);

    return results;
  }

  Future<List<PostWithProfileEntity>> fetchPosts(
    String orderBy, {
    int currentIndex = 1,
    int perPage = 5,
    required String category,
  }) async {
    int startIndex = currentIndex - 1;
    int endIndex = perPage - 1;

    // 현재 페이지가 첫 페이지가 아니라면
    if (currentIndex != 1) {
      endIndex = (currentIndex * perPage) - 1;
      startIndex = (currentIndex - 1) * perPage;
    }

    final String range = "${startIndex}-${endIndex}";

    // ✅ 현재 로그인된 유저의 세션 정보 가져오기
    // final supabase = Supabase.instance.client;
    // final session = supabase.auth.currentSession;
    // final accessToken = session?.accessToken;
    // print("accessToken : ${accessToken}");
    print("orderBy : ${orderBy}");

    // 만약 로그인이 안 되어 있으면 null일 수 있으니 체크
    // if (accessToken == null) {
    //   print("[fetchPosts] ⚠️ 로그인 토큰이 없습니다. 비로그인 상태로 요청합니다.");
    // }

    String authorizationKey = supabase.auth.currentSession?.accessToken != null
        ? 'Bearer ${supabase.auth.currentSession?.accessToken}'
        : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc';
    final response = await supabase.functions.invoke(
      'post-function/posts',
      method: HttpMethod.get,
      queryParameters: {'orderBy': orderBy, 'category': category},
      headers: {
        'Authorization': authorizationKey,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Range': range,
      },
    );
    debugPrint(
      'Authorization : Bearer ${supabase.auth.currentSession?.accessToken}',
    );

    // final data = res.data;

    // final Response<dynamic> response = (await dio.get(
    //   'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts?orderBy=${orderBy}&category=${category}',
    //   options: Options(
    //     headers: {
    //       'Authorization': 'Bearer ${accessToken}',
    //       'Content-Type': 'application/x-www-form-urlencoded',
    //       'Range': range,
    //     },
    //   ),
    // ));

    print("response 런타임타입 : ${response}");
    if (response.data['data'] != null) {
      final List data = response.data['data'];
      print("${data.runtimeType}");
      final List<PostWithProfileEntity> results = data.map((json) {
        return PostWithProfileEntity.fromJson(json);
      }).toList();

      return results;
    } else {
      return List.empty();
    }
  }

  Future<int> getPostLikeCount(int id) async {
    final response = await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts/${id}/likes_count',
      options: Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
          'Content-Type': 'application/json',
        },
      ),
    );

    final Map<String, dynamic> data = response.data['data'];
    print("data 데이터 타입 : ${data.runtimeType}");
    final LikesCountEntity results = LikesCountEntity.fromJson(data);

    return results.likes_count;
  }

  Future<CommentWithProfileEntity> fetchCommentItem(int id) async {
    final response = await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/comments/${id}',
      options: Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
          'Content-Type': 'application/json',
        },
      ),
    );

    final Map<String, dynamic> data = response.data['data'];
    print("data 데이터 타입 : ${data.runtimeType}");
    final CommentWithProfileEntity results = CommentWithProfileEntity.fromJson(
      data,
    );

    return results;
  }

  Future<List<CommentWithProfileEntity>> fetchComments(int postId) async {
    String authorizationKey = supabase.auth.currentSession?.accessToken != null
        ? 'Bearer ${supabase.auth.currentSession?.accessToken}'
        : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc';
    // final response = await supabase.functions.invoke(
    //   'post-function/comments',
    //   method: HttpMethod.get,
    //   queryParameters: {'post_id': "${postId}"},
    //   headers: {
    //     'Authorization': authorizationKey,
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //   },
    // );
    final response = await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/comment?post_id=${postId}',
      options: Options(
        headers: {
          'Authorization': authorizationKey,
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.data['data'] != null) {
      final List data = response.data['data'];
      print("${data.runtimeType}");
      final List<CommentWithProfileEntity> results = data.map((json) {
        return CommentWithProfileEntity.fromJson(json);
      }).toList();

      return results;
    } else {
      return List.empty();
    }
  }

  Future<void> insertPost(
    String userId,
    String title,
    String content,
    List<String> images,
    List<int> categories,
  ) async {
    try {
      await dio.post(
        'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts',
        options: Options(
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'author_id': userId,
          'title': title,
          'content': content,
          'images': images,
          'categories': categories,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePost(
    int postId,
    String title,
    String content,
    List<String> images,
    List<int> categories,
  ) async {
    try {
      await supabase.functions.invoke(
        'post-function/posts/${postId}',
        method: HttpMethod.put,
        body: {
          'title': title,
          'content': content,
          'images': images,
          'categories': categories,
        },
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<SearchResultEntity> searchAll(
    String keyword, {
    String type = "all",
    int currentIndex = 1,
    int perPage = 5,
  }) async {
    int startIndex = currentIndex - 1;
    int endIndex = perPage - 1;

    // 현재 페이지가 첫 페이지가 아니라면
    if (currentIndex != 1) {
      endIndex = (currentIndex * perPage) - 1;
      startIndex = (currentIndex - 1) * perPage;
    }

    final String range = "${startIndex}-${endIndex}";

    String authorizationKey = supabase.auth.currentSession?.accessToken != null
        ? 'Bearer ${supabase.auth.currentSession?.accessToken}'
        : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc';
    final response = await supabase.functions.invoke(
      'post-function/search',
      method: HttpMethod.get,
      queryParameters: {'keyword': keyword, 'type': type},
      headers: {
        'Authorization': authorizationKey,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Range': range,
      },
    );
    final Map<String, dynamic> data = response.data;
    print("${response}");
    print("${data}");
    SearchResultEntity result = SearchResultEntity.fromJson(data);

    return result;
  }

  Future<void> deletePost(int postId) async {
    await supabase.functions.invoke(
      'post-function/posts/${postId}',
      method: HttpMethod.delete,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
  }

  Future<List<PostWithProfileEntity>> fetchUserPosts(
    String userId, {
    int currentIndex = 1,
    int perPage = 12,
  }) async {
    int startIndex = currentIndex - 1;
    int endIndex = perPage - 1;

    // 현재 페이지가 첫 페이지가 아니라면
    if (currentIndex != 1) {
      endIndex = (currentIndex * perPage) - 1;
      startIndex = (currentIndex - 1) * perPage;
    }

    final String range = "${startIndex}-${endIndex}";

    String authorizationKey = supabase.auth.currentSession?.accessToken != null
        ? 'Bearer ${supabase.auth.currentSession?.accessToken}'
        : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc';
    final response = await supabase.functions.invoke(
      'post-function/users_posts',
      method: HttpMethod.get,
      queryParameters: {'userId': userId},
      headers: {
        'Authorization': authorizationKey,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Range': range,
      },
    );

    if (response.data['data'] != null) {
      final List data = response.data['data'];
      print("${data.runtimeType}");
      final List<PostWithProfileEntity> results = data.map((json) {
        return PostWithProfileEntity.fromJson(json);
      }).toList();

      return results;
    } else {
      return List.empty();
    }
  }
}

// curl --location 'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts/1' \
// --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc' \
// --header 'Content-Type: application/json'

// 페이징 처리 로직 예시
// Future<List<Memo>> fetchMemos({
//   int currentIndex = 1,
//   int perPage = 10,
// }) async {
//   // 호출: curl 에 있는 것을 그대로 호출해야 한다.
//   // 응답: 포스트맨에서 확인한 모양대로 응담을 받는다.
//   // int startIndex;
//   // int endIndex;
//   // if (currentIndex != 1) {
//   //   startIndex = (currentIndex * perPage) - 1;
//   //   endIndex = (currentIndex - 1) * perPage;
//   // } else {
//   //   startIndex = currentIndex - 1;
//   //   endIndex = perPage - 1;
//   // }
//   int startIndex = currentIndex - 1;
//   int endIndex = perPage - 1;
//
//   // 현재 페이지가 첫 페이지가 아니라면
//   if (currentIndex != 1) {
//     endIndex = (currentIndex * perPage) - 1;
//     startIndex = (currentIndex - 1) * perPage;
//   }
//
//   final String range = "${startIndex}-${endIndex}";
//
//   // 쌍따옴표 따옴표 상관없음(어머나???)
//   // 수파베이스 api에서 정렬
//   // ?order=컬럼.asc(오름차순) or desc(내림차순)
//
//   final response = await dio.get(
//     'https://wynrmjlvbeyjiyuyrcsv.supabase.co/rest/v1/newMemos?select=*&order=id.desc',
//     options: Options(
//       headers: {
//         'apikey': apiKey,
//         'Authorization': authorization,
//         'Range': range,
//       },
//     ),
//     // data: {'orderBy': 'created_at', 'order': 'desc'},
//   );
//
//   if (response.data != null) {
//     final List data = response.data;
//     final List<Memo> results = data.map((json) {
//       return Memo.fromJson(json);
//     }).toList();
//     return results;
//   } else {
//     return List.empty();
//   }
//
//   // final List<Memo> result = response.data!
//   //     .map((json) => Memo.fromJson(json))
//   //     .toList();
//   //
//   // return result;
// }
