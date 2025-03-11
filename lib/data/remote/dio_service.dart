import 'package:book/data/remote/book_response.dart';
import 'package:dio/dio.dart';

class dioService {
  late Dio _dio;
  final baseUrl = "https://www.googleapis.com/books/v1/";


  dioService() {
    _dio = Dio(
        BaseOptions(
            baseUrl: baseUrl,
        ),
    );
initializeInterceptors();
  }

  Future<List<BookResponse>> fetchBooks(String query) async{
    Response response;
    try{
      response=await _dio.get("volumes?q=\"$query\"");
      if (response.statusCode == 200) {
        List<dynamic> items = response.data['items']??[];
        return items.map((item) => BookResponse.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load books");
      }    }catch(e){
      print("Error: $e");
      throw Exception(e);
    }



  }


  initializeInterceptors(){
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error,handler){
        print(error.message);
        return handler.next(error);
      },
      onRequest: (request,handler){
        print(request.method);
        return handler.next(request);
    },
      onResponse: (response,handler){
        print(response.data);
        return handler.next(response);
      }
    ));
  }
}