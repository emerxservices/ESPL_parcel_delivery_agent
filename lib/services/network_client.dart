import 'package:dio/dio.dart';
import 'package:espl_parcel_driver/services/exception.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkClient extends GetxController {
  Dio _dio = Dio();
  // String baseUrl = 'http://34.201.244.184/ep';
  String baseUrl = "https://admin.sazuco.com/ep";

  RxBool loading = RxBool(false);

  NetworkClient() {
    BaseOptions baseOptions = BaseOptions(
        receiveTimeout: 80 * 1000,
        connectTimeout: 80 * 1000,
        baseUrl: baseUrl,
        maxRedirects: 2,
        responseType: ResponseType.json,
        contentType: "application/json");
    _dio = Dio(baseOptions);
    // adding logging interceptor.
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      error: true,
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  // for HTTP.GET Request.
  Future<Response> get(String url, Map<String, Object> params) async {
    SharedPreferences sharedP = await SharedPreferences.getInstance();
    loading.value = true;
    String? userToken = sharedP.getString('userToken');
    Response response;
    try {
      response = await _dio.get(url,
          queryParameters: params,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer $userToken"}));
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).toString();
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }

  // for HTTP.POST Request.
  Future<Response> post(String url, Map<String, Object> params) async {
    SharedPreferences sharedP = await SharedPreferences.getInstance();
    loading.value = true;
    String? userToken = sharedP.getString('userToken');
    Response response;
    try {
      response = await _dio.post(url,
          data: params,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer $userToken"}));
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).errorMessage;
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }

  Future<Response> postFormData(String url, dynamic params) async {
    SharedPreferences sharedP = await SharedPreferences.getInstance();
    loading.value = true;
    String? userToken = sharedP.getString('userToken');
    Response response;
    try {
      response = await _dio.post(url,
          data: params,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Accept": "application/json", "Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer $userToken"}));
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).errorMessage;
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }

  // for HTTP.PATCH Request.
  Future<Response> patch(String url, Map<String, Object> params) async {
    Response response;
    loading.value = true;
    try {
      response = await _dio.patch(url,
          data: params,
          options: Options(
            responseType: ResponseType.json,
          ));
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).toString();
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }

  // for dwonload Request.
  Future<Response> download(String url, String pathName, void Function(int, int)? onReceiveProgress) async {
    loading.value = true;
    Response response;
    try {
      response = await _dio.download(
        url,
        pathName,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).toString();
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }

  Future<Response> deleteUser(String pathName) async {
    SharedPreferences sharedP = await SharedPreferences.getInstance();

    String? userToken = sharedP.getString('userToken');
    loading.value = true;

    Response response;
    try {
      response = await _dio.delete(baseUrl + pathName,
          options: Options(
              responseType: ResponseType.json,
              headers: {"Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer $userToken"}));
      print('User deleted!');
    } on DioError catch (exception) {
      loading.value = false;
      final errorMessage = DioException.fromDioError(exception).toString();
      return Future.error(errorMessage.toString());
    } catch (exception) {
      loading.value = false;
      return Future.error(exception);
    }
    loading.value = false;
    return response;
  }
}
