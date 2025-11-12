import 'package:dio/dio.dart';
import 'package:new_bie/features/post/data/entity/comment_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/likes_count_entity.dart';
import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';

class NetworkApiManager {
  static final NetworkApiManager _shared = NetworkApiManager();

  static NetworkApiManager get shared => _shared;
  final dio = Dio();

  NetworkApiManager() {}

  Future<PostWithProfileEntity> fetchPostItem(int id) async {
    final response = await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts/${id}',
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
    final PostWithProfileEntity results = PostWithProfileEntity.fromJson(data);

    return results;
  }

  Future<List<PostWithProfileEntity>> fetchPosts(
    String orderBy, {
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

    final Response<dynamic> response = (await dio.get(
      'https://syfgficcejjgtvpmtkzx.supabase.co/functions/v1/post-function/posts?orderBy=${orderBy}',
      options: Options(
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5ZmdmaWNjZWpqZ3R2cG10a3p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNTUwNjksImV4cCI6MjA3NzYzMTA2OX0.Ng9atODZnfRocZPtnIb74s6PLeIJ2HqqSaatj1HbRsc',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Range': range,
        },
      ),
    ));

    print("response 런타임타입 : ${response.runtimeType}");
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

  Future<void> insertPost(
    String userId,
    String title,
    String content,
    List<String> images,
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
        },
      );
    } catch (e) {
      print(e);
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
