import 'package:dio/dio.dart';

class NetworkApiManager {
  static final NetworkApiManager _shared = NetworkApiManager();

  static NetworkApiManager get shared => _shared;
  final dio = Dio();

  NetworkApiManager() {}
}

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
